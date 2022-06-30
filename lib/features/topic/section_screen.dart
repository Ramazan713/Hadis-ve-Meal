import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/common_menu_items.dart';
import 'package:hadith/constants/enums/book_enum.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/utils/sourcetype_helper.dart';
import 'package:hadith/features/save_point/show_select_savepoint_with_book_dia.dart';
import 'package:hadith/features/topic/bloc/topic_event.dart';
import 'package:hadith/features/topic/model/section_argument.dart';
import 'package:hadith/features/topic/model/topic_argument.dart';

import 'package:hadith/features/topic/topic_screen.dart';
import 'package:hadith/features/topic/widget/topic_tile_item.dart';
import 'package:hadith/widgets/custom_search_sliver_appbar.dart';
import 'package:hadith/widgets/custom_sliver_appbar.dart';
import 'package:hadith/widgets/custom_sliver_nested_scrollview.dart';

import '../../models/shimmer/shimmer_widgets.dart';
import 'bloc/section_bloc.dart';
import 'bloc/topic_state.dart';

class SectionScreen extends StatefulWidget {
  static String id = "SectionScreen";
  const SectionScreen({Key? key}) : super(key: key);

  @override
  State<SectionScreen> createState() => _SectionScreenState();
}

class _SectionScreenState extends State<SectionScreen> {
  final searchController = TextEditingController();
  Timer? _timer;
  late final CustomSearchSliverAppBar searchSliverBar;
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
        (ModalRoute.of(context)?.settings.arguments as SectionArgument?) ??
            SectionArgument();

    final title =
        "Bölüm - ${SourceTypeHelper.getNameWithBookBinaryId(argument.bookEnum.bookIdBinary)}";

    return CustomSliverAppBar(
      snap: true,
      floating: true,
      pinned: true,
      title: Text(title),
      actions: [
        getSavePointIcon(onPress: (){
          showSelectSavePointWithBookDia(context,
              bookEnum: argument.bookEnum,
              bookBinaryIds: [argument.bookEnum.bookIdBinary],
              filter: OriginTag.topic);
        }),
        searchSliverBar.getIconButton()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SectionBloc>();

    final argument =
        (ModalRoute.of(context)?.settings.arguments as SectionArgument?) ??
            SectionArgument();
    bloc.add(SectionEventRequest(bookId: argument.bookEnum.bookId));

    searchController.addListener(() {
      _timer?.cancel();
      _timer = Timer(const Duration(milliseconds: 400), () {
        final text = searchController.text.trim();
        bloc.add(SectionEventRequest(
            bookId: argument.bookEnum.bookId, searchCriteria: text));
      });
    });

    return WillPopScope(
      onWillPop: (){
        bool resultVal;
        if(searchSliverBar.isSearchBar){
          resultVal=false;
          searchSliverBar.isSearchBar=false;
        }else{
          resultVal=true;
        }
        return Future.value(resultVal);
      },
      child: Scaffold(
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
              Expanded(child:
                  BlocBuilder<SectionBloc, TopicState>(builder: (context, state) {
                if (state.status == DataStatus.loading) {
                  return ListView.builder(itemBuilder: (context, index) {
                    return getTopicShimmer(context);
                  },itemCount: 19,);
                }

                final items = state.topics;
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return TopicTileItem(
                        isSavePoint: false,
                        itemLabel: "başlık",
                        itemCountModel: item,
                        onTap: () {
                          Navigator.pushNamed(context, TopicScreen.id,
                              arguments: TopicArgument(
                                  bookEnum: argument.bookEnum,
                                  sectionId: item.id,
                                  title: item.name));
                        });
                  },
                  itemCount: items.length,
                );
              })),
            ],
          ),
        ),
      )),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}
