import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hadith/constants/common_menu_items.dart';
import 'package:hadith/constants/enums/book_enum.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/constants/enums/topic_savepoint_enum.dart';
import 'package:hadith/db/entities/surah.dart';
import 'package:hadith/features/paging/paging_argument.dart';
import 'package:hadith/features/paging/verse_loader/verse_surah_paging_loader.dart';
import 'package:hadith/features/save_point/show_select_savepoint_with_book_dia.dart';
import 'package:hadith/features/topic_savepoint/bloc/topic_savepoint_event.dart';
import 'package:hadith/features/topic_savepoint/topic_savepoint_page_state.dart';
import 'package:hadith/features/verse/verse_screen.dart';
import 'package:hadith/widgets/custom_search_sliver_appbar.dart';
import 'package:hadith/widgets/custom_sliver_appbar.dart';
import 'package:hadith/widgets/custom_sliver_nested_scrollview.dart';
import 'package:hadith/widgets/topic_icon_item.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../models/save_point_argument.dart';
import 'bloc/surah_bloc.dart';
import 'bloc/surah_event.dart';
import 'bloc/surah_state.dart';

class SurahScreen extends StatefulWidget {
  static const id = "SurahScreen";
  const SurahScreen({Key? key}) : super(key: key);

  @override
  State<SurahScreen> createState() => _SurahScreenState();
}

class _SurahScreenState extends TopicSavePointPageState<SurahScreen> {
  Timer? _timer;
  final OriginTag originTag=OriginTag.surah;
  final ValueNotifier<bool> rebuildAppbarNotifier=ValueNotifier(false);
  final TopicSavePointEnum _topicSavePointEnum=TopicSavePointEnum.surah;

  @override
  void initState() {
    super.initState();
    searchSliverBar=CustomSearchSliverAppBar(defaultSliverAppbar: getDefaultSliverBar,
        rebuildNotifier: rebuildAppbarNotifier,
        controller: searchController);
  }

  SliverAppBar getDefaultSliverBar(BuildContext context){
    return  CustomSliverAppBar(
      pinned: true,
      title: const Text("Sure"),
      actions: [
        getSavePointIcon(onPress: (){
          showSelectSavePointWithBookDia(context,
              bookEnum: BookEnum.dinayetMeal,
              bookBinaryIds: [BookEnum.dinayetMeal.bookIdBinary],
              filter: OriginTag.surah);
        }),
        searchSliverBar.getIconButton()
      ],
    );
  }

  void _execSearching(SurahBloc bloc){
    searchController.addListener(() {
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 400), () {
        final text = searchController.text.trim();
        bloc.add(SurahEventRequested(searchCriteria: text));
      });
    });
  }

  void _navigateTo(Surah item,bool loadClosedPoint){
    final arg = PagingArgument(
        bookIdBinary: BookEnum.dinayetMeal.bookIdBinary,
        savePointArg: SavePointArg(parentKey: item.id.toString(),loadNearPoint: loadClosedPoint),
        title: item.name,
        originTag: originTag,
        loader: VerseSurahPagingLoader(
            context: context,
            surahId: item.id
        )
    );
    Navigator.pushNamed(context, VerseScreen.id,
        arguments: arg);
  }


  @override
  Widget buildPage(BuildContext context) {
    final bloc=context.read<SurahBloc>();
    bloc.add(SurahEventRequested());

    _execSearching(bloc);

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
              child: getSavePointBloc(
                child: BlocBuilder<SurahBloc,SurahState>(
                  builder: (context, state) {

                    if (state.status == DataStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    savePointBloc.add(TopicSavePointEventRequest(
                        topicSavePointEnum: _topicSavePointEnum,
                        parentKey:_topicSavePointEnum.defaultParentKey));

                    final items=state.items;
                    final isSearching = searchController.text.trim() != "";

                    return ScrollablePositionedList.builder(
                      itemPositionsListener: itemPositionsListener,
                      itemScrollController: itemScrollController,
                      itemBuilder: (context,index){
                      final item=items[index];
                      return ValueListenableBuilder(
                          valueListenable: rebuildItems,
                          builder: (context,value,child){
                            return TopicIconItem(label: "${item.id}. ${item.name} ",
                                iconData: FontAwesomeIcons.bookQuran,
                                trailing: (lastSavePoint?.pos ==item.id)?getPointWidget(context):null,
                                onLongPress: isSearching?null:(){
                                  showBottomMenuFunc(pos: item.id, navigate: (){
                                    _navigateTo(item,true);
                                  }, topicSavePointEnum: _topicSavePointEnum,
                                      parentKey: _topicSavePointEnum.defaultParentKey);
                                },
                                onTap: (){
                                  _navigateTo(item,false);
                                });
                          });
                    },itemCount: items.length,);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      ),
      floatingActionButton: getFloatingButton(context),
    );
  }

  @override
  bool useSearchSliverBar() => true;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
