import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hadith/constants/common_menu_items.dart';
import 'package:hadith/constants/enums/book_enum.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/constants/enums/topic_savepoint_enum.dart';
import 'package:hadith/db/entities/cuz.dart';
import 'package:hadith/features/paging/paging_argument.dart';
import 'package:hadith/features/paging/verse_loader/verse_cuz_paging_loader.dart';
import 'package:hadith/features/save_point/show_select_savepoint_with_book_dia.dart';
import 'package:hadith/features/verse/verse_screen.dart';
import 'package:hadith/models/save_point_argument.dart';
import 'package:hadith/widgets/custom_sliver_appbar.dart';
import 'package:hadith/widgets/custom_sliver_nested_scrollview.dart';
import 'package:hadith/widgets/topic_icon_item.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../topic_savepoint/bloc/topic_savepoint_event.dart';
import '../../topic_savepoint/topic_savepoint_page_state.dart';
import 'bloc/cuz_bloc.dart';
import 'bloc/cuz_event.dart';
import 'bloc/cuz_state.dart';

class CuzScreen extends StatefulWidget {
  static const id = "CuzScreen";
  const CuzScreen({Key? key}) : super(key: key);

  @override
  State<CuzScreen> createState() => _CuzScreenState();
}

class _CuzScreenState extends TopicSavePointPageState<CuzScreen> {
  final OriginTag originTag = OriginTag.cuz;
  final TopicSavePointEnum _topicSavePointEnum=TopicSavePointEnum.cuz;


  void _navigateTo(Cuz item,bool loadNearPoint){
    final loader = VerseCuzPagingLoader(
        context: context, cuzNo: item.cuzNo);
    final argument = PagingArgument(
        loader: loader,
        bookIdBinary: BookEnum.dinayetMeal.bookIdBinary,
        savePointArg: SavePointArg(parentKey: item.cuzNo.toString(),loadNearPoint:loadNearPoint),
        originTag: originTag,
        title: item.name);
    Navigator.pushNamed(context, VerseScreen.id,
        arguments: argument);
  }


  @override
  Widget buildPage(BuildContext context) {
    final bloc = context.read<CuzBloc>();
    bloc.add(CuzEventRequested());

    return Scaffold(
      body: SafeArea(
        child: CustomSliverNestedView(
          context,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              CustomSliverAppBar(
                pinned: true,
                title: const Text("Cüz"),
                actions: [
                  getSavePointIcon(onPress: (){
                    showSelectSavePointWithBookDia(context,
                        bookEnum: BookEnum.dinayetMeal,
                        bookBinaryIds: [BookEnum.dinayetMeal.bookIdBinary],
                        filter: OriginTag.cuz);
                  }),
                ],
              ),
            ];
          },
          isBottomNavAffected: false,
          child: Column(
            children: [
              getListenableItemPosition(),
              Expanded(
                child:
                getSavePointBloc(
                  child: BlocBuilder<CuzBloc, CuzState>(builder: (context, state) {

                    if(state.status==DataStatus.loading){
                      return const Center(child:  CircularProgressIndicator(),);
                    }

                    savePointBloc.add(TopicSavePointEventRequest(
                        topicSavePointEnum: _topicSavePointEnum,
                        parentKey:_topicSavePointEnum.defaultParentKey));
                    
                    final items = state.items;
                    return ScrollablePositionedList.builder(
                      itemScrollController: itemScrollController,
                      itemPositionsListener: itemPositionsListener,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ValueListenableBuilder(
                            valueListenable: rebuildItems,
                            builder: (context,value,child){
                             return TopicIconItem(
                               trailing: (lastSavePoint?.pos ==item.cuzNo)?getPointWidget(context):null,
                                 label: item.name,
                                 iconData: FontAwesomeIcons.bookQuran,
                                 onLongPress: (){
                                   showBottomMenuFunc(pos: item.cuzNo, navigate: (){
                                     _navigateTo(item,true);
                                   }, topicSavePointEnum: _topicSavePointEnum,
                                       parentKey: _topicSavePointEnum.defaultParentKey);
                                 },
                                 onTap: () {
                                   _navigateTo(item,false);
                                 }); 
                            });
                      },
                      itemCount: items.length,
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),floatingActionButton: getFloatingButton(context),
    );
  }
  @override
  bool useSearchSliverBar() => false;
}
