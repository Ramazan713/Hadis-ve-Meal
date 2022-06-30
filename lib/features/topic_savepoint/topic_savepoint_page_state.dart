import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/bloc/visibility_bloc/visibility_bloc.dart';
import 'package:hadith/bloc/visibility_bloc/visibility_event.dart';
import 'package:hadith/bloc/visibility_bloc/visibility_state.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/topic_savepoint_enum.dart';
import 'package:hadith/db/entities/savepoint.dart';
import 'package:hadith/db/entities/topic_savepoint_entity.dart';
import 'package:hadith/dialogs/show_bottom_menu.dart';
import 'package:hadith/utils/toast_utils.dart';
import 'package:hadith/widgets/custom_animated_widget.dart';
import 'package:hadith/widgets/custom_search_sliver_appbar.dart';
import 'package:hadith/widgets/menu_item_tile.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'bloc/topic_savepoint_bloc.dart';
import 'bloc/topic_savepoint_event.dart';
import 'bloc/topic_savepoint_state.dart';

abstract class TopicSavePointPageState <T extends StatefulWidget> extends State<T>{
  final ItemScrollController itemScrollController=ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final searchController = TextEditingController();
  late final CustomSearchSliverAppBar searchSliverBar;


  TopicSavePointEntity? lastSavePoint;
  final ValueNotifier rebuildItems=ValueNotifier(false);
  late TopicSavePointBloc savePointBloc;
  late VisibilityBloc visibilityBloc;


  int min=0;
  int max=0;
  int currentIndex=0;
  int prevMin=0;
  bool isScrollUp=true;

  bool useSearchSliverBar();

  Widget buildPage(BuildContext context);

  @override
  Widget build(BuildContext context) {
    savePointBloc = context.read<TopicSavePointBloc>();
    visibilityBloc=context.read<VisibilityBloc>();

    visibilityBloc.add(VisibilityEventSet(isVisible: false));


    return WillPopScope(onWillPop: (){

      if(!useSearchSliverBar()){
        return Future.value(true);
      }
      bool resultVal;
      if(searchSliverBar.isSearchBar){
        resultVal=false;
        searchSliverBar.isSearchBar=false;
      }else{
        resultVal=true;
      }

      return Future.value(resultVal);
    },child: buildPage(context));
  }

  ValueListenableBuilder getListenableItemPosition(){
    return  ValueListenableBuilder<Iterable<ItemPosition>>(valueListenable: itemPositionsListener.itemPositions,
        builder: (context,positions,child){
          if(positions.isNotEmpty){
            if(positions.first.index<positions.last.index){
              min=positions.first.index;
              max=positions.last.index;
            }else{
              min=positions.last.index;
              max=positions.first.index;
            }
            if(prevMin!=min){
              if(prevMin>min&&!isScrollUp&&searchController.text==""){//scroll up
                isScrollUp=true;
                visibilityBloc.add(VisibilityEventSet(isVisible: lastSavePoint!=null&&isScrollUp,option: 1));
              }
              if(prevMin<min&&isScrollUp&&searchController.text==""){// scroll down
                isScrollUp=false;
                visibilityBloc.add(VisibilityEventSet(isVisible: lastSavePoint!=null&&isScrollUp,option: 1));
              }
              currentIndex=(min+max)~/2;
              prevMin=min;
            }

          }
          return const SizedBox();
        });
  }

  void rebuildItemFunc(){
    rebuildItems.value=!rebuildItems.value;
  }

  void showBottomMenuFunc({required int pos,required Function()navigate,
    required TopicSavePointEnum topicSavePointEnum,required String parentKey,
    SavePoint? savePoint}){

    final isSavePoint=lastSavePoint?.pos==pos;

    final items=[
      IconTextItem(
          title: "Git (son kayıt noktası)",
          iconData: Icons.login,
          onTap:(){
            Navigator.pop(context);
            navigate.call();
          }),
      IconTextItem(
          title: isSavePoint?"İşareti Kaldır":"İşaretle",
          iconData: Icons.save_outlined,
          onTap: () {
            if(isSavePoint){
              final savePoint=lastSavePoint?.copyWith(keepOldId: true);
              if(savePoint!=null) {
                savePointBloc.add(TopicSavePointEventDelete(topicSavePointEntity: savePoint));
                lastSavePoint=null;
                visibilityBloc.add(VisibilityEventSet(isVisible: false,option: 2));
                rebuildItemFunc();
              }
            }else{
              savePointBloc.add(
                TopicSavePointEventInsert(
                  topicSavePointEnum: topicSavePointEnum,
                  topicSavePointEntity: TopicSavePointEntity(
                      parentKey: parentKey,
                      pos: pos,
                      type: topicSavePointEnum),
                ),
              );
            }
            ToastUtils.showLongToast("Başarılı");
            Navigator.pop(context);
          }),
    ];
    if(savePoint!=null){
      items.insert(1, IconTextItem(onTap: () {
        Navigator.pop(context);
        navigate.call();
      },
        iconData: Icons.login_rounded, title: '${savePoint.itemIndexPos} pos\'a Git',));
    }

    showBottomMenu(context, items: items);
  }

  Widget getSavePointBloc({required Widget child}){
    return BlocListener<TopicSavePointBloc,TopicSavePointState>(
        listener: (context,state){
      if(state.status==DataStatus.success){
        if(state.topicSavePointEntity!=null){
          lastSavePoint=state.topicSavePointEntity;

          visibilityBloc.add(VisibilityEventSet(isVisible: searchController.text=="",option: 2));
          rebuildItems.value=!rebuildItems.value;
        }
      }
    },
    child: child
    ,);
  }

  Widget getFloatingButton(BuildContext context){
    return BlocBuilder<VisibilityBloc,VisibilityState>(
      builder: (context,state){
        return  CustomAnimatedWidget(
          value: state.isVisible,
          duration: const Duration(milliseconds: 200),
          child: FloatingActionButton(
            child: const Icon(Icons.beenhere),
            backgroundColor:  Theme.of(context).errorColor,
            onPressed: (){
              itemScrollController.scrollTo(index: (lastSavePoint?.pos)??0, duration: const Duration(milliseconds: 400),alignment: 0.5);
                visibilityBloc.add(VisibilityEventSet(isVisible: false));
              },
          ),
        );
      },
    );
  }

  Widget getPointWidget(BuildContext context){
    return Icon(Icons.beenhere,color: Theme.of(context).errorColor,);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}