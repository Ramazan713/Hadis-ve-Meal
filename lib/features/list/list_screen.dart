import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/app_constants.dart';
import 'package:hadith/constants/common_menu_items.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/list_edit_enum.dart';
import 'package:hadith/dialogs/show_bottom_select_menu_items_enum.dart';
import 'package:hadith/features/bottom_nav/widget/bottom_nav_widget_state.dart';
import 'package:hadith/features/list/bloc/blocs/list_hadith_bloc.dart';
import 'package:hadith/features/list/bloc/blocs/list_verse_bloc.dart';
import 'package:hadith/features/list/bloc/state/list_hadith_state.dart';
import 'package:hadith/features/list/bloc/state/list_verse_state.dart';
import 'package:hadith/features/list/list_archive_screen.dart';
import 'package:hadith/features/list/list_funcs.dart';
import 'package:hadith/models/shimmer/shimmer_widgets.dart';
import 'package:hadith/utils/toast_utils.dart';
import 'package:hadith/widgets/custom_search_sliver_appbar.dart';
import 'package:hadith/widgets/custom_animated_widget.dart';
import 'package:hadith/widgets/custom_sliver_appbar.dart';
import 'package:hadith/widgets/custom_sliver_nested_scrollview.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';
import 'package:hadith/dialogs/edit_text_bottom_dia.dart';
import 'package:hadith/features/list/model/list_bloc_context.dart';
import 'package:hadith/features/list/widget/list_tile_item.dart';

import '../../constants/enums/sourcetype_enum.dart';
import 'bloc/state/i_list_count_state.dart';

class ListScreen extends StatefulWidget{
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends BottomNavWidgetState<ListScreen> {
  var _currentTabIndex = 0;

  TextEditingController searchEditController = TextEditingController();
  final ValueNotifier<bool> rebuildAppbarNotifier=ValueNotifier(false);

  Timer? _timer;
  ListBlocContext blocContext = ListBlocContext();

  final fabVisibilityNotifier = ValueNotifier<bool>(true);

  late CustomSearchSliverAppBar customSearchSliverBar;

  _ListScreenState() {
    customSearchSliverBar=CustomSearchSliverAppBar(defaultSliverAppbar: getDefaultSliverAppbar,
        controller: searchEditController,rebuildNotifier: rebuildAppbarNotifier,onChanged: (text){
          _timer?.cancel();
          _timer = Timer(const Duration(milliseconds: kTimerDelaySearchMilliSecond), () {
            blocContext.requestLoadItems(searchCriteria: text);
          });
        });
  }

  void _executeMenu(IListView item, BuildContext context){
    List<ListEditEnum> listEnums = [
      ListEditEnum.rename,
      ListEditEnum.exportAs,
      ListEditEnum.newCopy
    ];
    if(item.isRemovable){
      listEnums.insert(1,ListEditEnum.remove,);
      listEnums.insert(3,ListEditEnum.archive,);
    }else{
      listEnums.insert(1, ListEditEnum.removeItems);
    }

    final items=getAskedListIconTextItems(context,listEnums: listEnums,isPop: true,item: item,
    selectedItem: (listEnum){
      switch (listEnum) {
        case ListEditEnum.rename:
          showEditTextBottomDia(context, (newText) {
            blocContext.renameItem(newText, item);
          }, title: "Yeniden İsimlendir", content: item.name);
          break;
        case ListEditEnum.remove:
          if(item.isRemovable){
            blocContext.removeItem(item);
          }
          break;
        case ListEditEnum.exportAs:
          break;
        case ListEditEnum.newCopy:
          blocContext.copyNewList(item);
          break;
        case ListEditEnum.archive:
          if(item.isRemovable){
            blocContext.sendToArchive(item);
            ToastUtils.showLongToast("Arşivlendi");
          }
          break;
        case ListEditEnum.unArchive:
          break;
        case ListEditEnum.removeItems:
          final SourceTypeEnum sourceTypeEnum = blocContext.getSourceType();
          blocContext.removeItemsInList(item, sourceTypeEnum);
          break;
      }
    });

    showSelectMenuItemDia(context, items: items,title: "'${item.name}' listesi için");
  }

  ListView getListView(List<IListView> items, BuildContext context) {
    final sourceTypeEnum=blocContext.getSourceType();

    return ListView.builder(
      itemBuilder: (context, index) {
        var item = items[index];
        return ListTileItem(
          sourceTypeEnum: sourceTypeEnum,
          defaultIcon: blocContext.getDefaultListIcon(context),
            listModel: item,
            onTap: () {
              blocContext.pushNamedNavigator(item, context);
            },
            menuListener: () {
              _executeMenu(item,context);
            });
      },
      itemCount: items.length,
    );
  }

  Widget getBlocView(IListCountState state, BuildContext context) {
    if (state.status == DataStatus.loading) {
      return ListView.builder(itemBuilder: (context, index) {
        return getListShimmer(context);
      },itemCount: 1,);
    } else {
      return getListView(state.listItems, context);
    }
  }

  SliverAppBar getDefaultSliverAppbar(BuildContext context){

    return CustomSliverAppBar(
      title: const Text("Listeler"),
      pinned: true,
      snap: true,
      floating: true,
      actions: [
        IconButton(onPressed: (){
          Navigator.pushNamed(context, ListArchiveScreen.id);
        }, icon: const Icon(Icons.archive),tooltip: "Arşiv",),
        customSearchSliverBar.getIconButton(),
        getSettingIcon(context)
      ],
      bottom: TabBar(
        onTap: (index){
          _currentTabIndex = index;
          blocContext.setBlockState(index, context);
          blocContext.requestLoadItems();
        },
        tabs: const [
          Tab(
            text: "Hadis",
          ),
          Tab(
            text: "Ayet",
          ),
        ],
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context) {

    blocContext.setBlockState(_currentTabIndex, context);
    blocContext.requestLoadItems();
    return WillPopScope(
      onWillPop: (){
        bool resultVal;
        if(customSearchSliverBar.isSearchBar){
          resultVal=false;
          customSearchSliverBar.isSearchBar=false;
          blocContext.requestLoadItems(searchCriteria: null);
        }else{
          resultVal=true;
        }
        return Future.value(resultVal);
      },
      child: DefaultTabController(
        initialIndex: _currentTabIndex,
        length: 2,
        child:Scaffold(
          resizeToAvoidBottomInset: kResizeToAvoidBottomInset,
            body: SafeArea(
              child: CustomSliverNestedView(context,
                child: Stack(
                  children: [
                    TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          BlocBuilder<ListHadithBloc, ListHadithState>(
                              builder: (context, state) {
                                return getBlocView(state, context);
                              }),
                          BlocBuilder<ListVerseBloc, ListVerseState>(
                              builder: (context, state) {
                                return getBlocView(state, context);
                              }),
                        ]),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: ValueListenableBuilder<bool>(
                        valueListenable: fabVisibilityNotifier,
                        builder: (context, val, child) {
                          return CustomAnimatedWidget(
                            value: val,
                            child: FloatingActionButton(
                              onPressed: (){
                                showEditTextBottomDia(context, (text) {
                                  blocContext.insertListItem(text);
                                },title: "Başlık Girin");
                              },
                              child: const Icon(Icons.add),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),

                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  fabVisibilityNotifier.value = !innerBoxIsScrolled;
                  return [
                    ValueListenableBuilder(valueListenable: rebuildAppbarNotifier,
                        builder: (context,value,child){
                          return customSearchSliverBar.build(context);
                        })
                  ];
                }, isBottomNavAffected: true,
              ),
            )),
      ),
    );
  }

}
