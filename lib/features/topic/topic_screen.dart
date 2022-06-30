import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/common_menu_items.dart';
import 'package:hadith/constants/enums/book_enum.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/constants/enums/sourcetype_enum.dart';
import 'package:hadith/constants/enums/topic_savepoint_enum.dart';
import 'package:hadith/features/topic_savepoint/topic_savepoint_page_state.dart';
import 'package:hadith/models/save_point_argument.dart';
import 'package:hadith/models/shimmer/shimmer_widgets.dart';
import 'package:hadith/utils/sourcetype_helper.dart';
import 'package:hadith/db/entities/helper/item_count_model.dart';
import 'package:hadith/dialogs/show_get_number_bottom_dia.dart';
import 'package:hadith/features/hadith/hadith_router.dart';
import 'package:hadith/features/paging/paging_argument.dart';
import 'package:hadith/features/paging/verse_loader/verse_topic_paging_loader.dart';

import 'package:hadith/features/topic/bloc/topic_event.dart';
import 'package:hadith/features/topic/bloc/topic_state.dart';
import 'package:hadith/features/topic/model/topic_argument.dart';
import 'package:hadith/features/topic/widget/topic_tile_item.dart';
import 'package:hadith/features/topic_savepoint/bloc/topic_savepoint_event.dart';
import 'package:hadith/features/verse/verse_screen.dart';
import 'package:hadith/features/paging/hadith_loader/hadith_topic_paging_loader.dart';
import 'package:hadith/widgets/custom_search_sliver_appbar.dart';
import 'package:hadith/widgets/custom_sliver_appbar.dart';
import 'package:hadith/widgets/custom_sliver_nested_scrollview.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'bloc/topic_bloc.dart';

class TopicScreen extends StatefulWidget {
  static String id = "TopicScreen";

  const TopicScreen({Key? key}) : super(key: key);

  @override
  State<TopicScreen> createState() => _TopicScreenState();
}

class _TopicScreenState extends TopicSavePointPageState<TopicScreen> {
  Timer? _timer;
  final OriginTag originTag = OriginTag.topic;

  int itemSize=1;

  final ValueNotifier<bool> rebuildAppbarNotifier=ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    searchSliverBar = CustomSearchSliverAppBar(
        defaultSliverAppbar: getDefaultAppBar,
        rebuildNotifier: rebuildAppbarNotifier,
        controller: searchController);
  }

  SliverAppBar getDefaultAppBar(BuildContext context) {
    final argument =
        (ModalRoute.of(context)?.settings.arguments as TopicArgument?) ??
            TopicArgument();

    final title =
        "${argument.title} - ${SourceTypeHelper.getNameWithBookBinaryId(argument.bookEnum.bookIdBinary)}";

    return CustomSliverAppBar(
      pinned: true,
      title: Text(title),
      actions: [
        getMapIcon(onPress: (){
          showGetNumberBottomDia(context, (selected){
            itemScrollController.scrollTo(index: selected, duration: const Duration(milliseconds: 300),alignment: 0.5);
          }, currentIndex: currentIndex, limitIndex: itemSize-1);
        }),
        searchSliverBar.getIconButton(),

      ],
    );
  }

  void _execSearching(
      TopicBloc bloc, TopicArgument argument, SourceTypeEnum sourceTypeEnum) {
    searchController.addListener(() {
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 400), () {
        final text = searchController.text.trim();
        bloc.add(TopicEventRequest(
            sourceTypeEnum: sourceTypeEnum,
            bookId: argument.bookEnum.bookId,
            sectionId: argument.sectionId,
            searchCriteria: text));
      });
    });
  }

  void _navigateToPaging(TopicArgument argument, SourceTypeEnum sourceTypeEnum,
      ItemCountModel item,bool loadNearPoint) {
    switch (sourceTypeEnum) {
      case SourceTypeEnum.hadith:
        final arg = PagingArgument(
            bookIdBinary: argument.bookEnum.bookIdBinary,
            savePointArg: SavePointArg(parentKey: item.id.toString(),loadNearPoint: loadNearPoint),
            title: item.name,
            originTag: originTag,
            loader:
                HadithTopicPagingLoader(context: context, topicId: item.id));
        routeHadithPage(context, arg);
        break;
      case SourceTypeEnum.verse:
        final arg = PagingArgument(
            bookIdBinary: argument.bookEnum.bookIdBinary,
            savePointArg: SavePointArg(parentKey: item.id.toString(),loadNearPoint:loadNearPoint),
            originTag: originTag,
            title: item.name,
            loader: VerseTopicPagingLoader(context: context, topicId: item.id));
        Navigator.pushNamed(context, VerseScreen.id, arguments: arg);
        break;
    }
  }



  String getTopicSavePointKey(TopicArgument argument){
    if(argument.sectionId==0){
      return (-argument.bookEnum.bookId).toString();
    }
    return argument.sectionId.toString();
  }




  @override
  Widget buildPage(BuildContext context) {
    final bloc = context.read<TopicBloc>();

    final argument =
        (ModalRoute.of(context)?.settings.arguments as TopicArgument?) ??
            TopicArgument();

    final SourceTypeEnum sourceTypeEnum =
        SourceTypeHelper.getSourceTypeWithBookBinaryId(
            argument.bookEnum.bookIdBinary);

    bloc.add(TopicEventRequest(
        bookId: argument.bookEnum.bookId,
        sourceTypeEnum: sourceTypeEnum,
        sectionId: argument.sectionId));

    _execSearching(bloc, argument, sourceTypeEnum);

    return Scaffold(
      body: SafeArea(
        child: CustomSliverNestedView(
          context,
          isBottomNavAffected: false,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              ValueListenableBuilder(valueListenable: rebuildAppbarNotifier,
                  builder: (context,value,child){
                return searchSliverBar.build(context);
              })
            ];
          },
          child: Column(
            children: [
              getListenableItemPosition(),
              Expanded(
                  child:getSavePointBloc(
                      child: BlocBuilder<TopicBloc, TopicState>(
                      builder: (context, state) {
                        if (state.status == DataStatus.loading) {
                          return ListView.builder(itemBuilder: (context, index) {
                            return getTopicShimmer(context);
                          },itemCount: 19,);
                        }
                        savePointBloc.add(TopicSavePointEventRequest(
                            topicSavePointEnum: TopicSavePointEnum.topic,
                            parentKey:getTopicSavePointKey(argument)));

                        final items = state.topics;
                        itemSize=items.length;
                        final isSearching = searchController.text.trim() != "";
                        return ScrollablePositionedList.builder(
                          itemPositionsListener: itemPositionsListener,
                          itemScrollController: itemScrollController,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return ValueListenableBuilder(
                                valueListenable: rebuildItems,
                                builder: (context, value, child) {
                                  return TopicTileItem(
                                    isSavePoint: lastSavePoint?.pos == item.rowNumber,
                                    itemLabel: sourceTypeEnum.shortName,
                                    itemCountModel: item,
                                    onTap: () {
                                      _navigateToPaging(
                                          argument, sourceTypeEnum, item,false);
                                    },
                                    onLongPress: isSearching
                                        ? null
                                        : () {
                                      showBottomMenuFunc(
                                        pos: item.rowNumber??0,
                                        topicSavePointEnum: TopicSavePointEnum.topic,
                                        parentKey: getTopicSavePointKey(argument),
                                        navigate: (){
                                          _navigateToPaging(
                                              argument, sourceTypeEnum, item,true);
                                        }
                                      );
                                    },
                                  );
                                });
                          },
                          itemCount: items.length,
                        );
                      })))
            ],
          ),
        ),
      ),
      floatingActionButton: getFloatingButton(context)
    );
  }
  @override
  bool useSearchSliverBar() => true;
}
