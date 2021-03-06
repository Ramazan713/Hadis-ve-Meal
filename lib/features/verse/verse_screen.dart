import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_paging_status_enum.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/font_size_enum.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/constants/enums/sourcetype_enum.dart';
import 'package:hadith/constants/enums/verse_arabic_ui_enum.dart';
import 'package:hadith/constants/enums/verse_edit_enum.dart';
import 'package:hadith/constants/favori_list.dart';
import 'package:hadith/constants/menu_resources.dart';
import 'package:hadith/constants/preference_constants.dart';
import 'package:hadith/dialogs/show_get_number_bottom_dia.dart';
import 'package:hadith/dialogs/show_select_font_size_bottom_dia.dart';
import 'package:hadith/dialogs/show_select_radio_enums.dart';
import 'package:hadith/features/paging/bloc/paging_bloc.dart';
import 'package:hadith/features/verse/verse_bottom_menu.dart';
import 'package:hadith/features/add_to_list/model/edit_select_list_model.dart';
import 'package:hadith/features/add_to_list/bloc/list_bloc.dart';
import 'package:hadith/features/add_to_list/model/select_verse_list_loader.dart';
import 'package:hadith/features/display_page_state.dart';
import 'package:hadith/features/paging/i_paging_loader.dart';
import 'package:hadith/features/paging/paging_argument.dart';
import 'package:hadith/features/save_point/bloc/save_point_bloc.dart';
import 'package:hadith/features/save_point/bloc/save_point_state.dart';
import 'package:hadith/features/save_point/show_select_savepoint_bottom_dia.dart';
import 'package:hadith/models/item_label_model.dart';
import 'package:hadith/utils/localstorage.dart';
import 'package:hadith/utils/share_utils.dart';
import 'package:hadith/features/share/show_preview_share_image_dia.dart';
import 'package:hadith/features/share/show_share_alert_dialog.dart';
import 'package:hadith/features/share/widget/list_tile_share_item.dart';
import 'package:hadith/features/verse/widget/verse_item.dart';
import 'package:hadith/models/shimmer/shimmer_widgets.dart';
import 'package:hadith/widgets/custom_sliver_appbar.dart';
import 'package:hadith/widgets/custom_sliver_nested_scrollview.dart';
import 'package:hadith/widgets/menu_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_constants.dart';
import '../paging/widgets/custom_scrolling_paging.dart';
import 'model/verse_model.dart';




class VerseScreen extends StatefulWidget {
  static const id = "VerseScreen";
  const VerseScreen({Key? key}) : super(key: key);

  @override
  State<VerseScreen> createState() => _VerseScreenState();
}

class _VerseScreenState extends DisplayPageState<VerseScreen> {

  final SharedPreferences sharedPreferences=LocalStorage.sharedPreferences;
  late final bool useArchiveListFeatures;
  late final bool showListVerseIcons;

  ArabicVerseUIEnum lastSelectedArabicUI=ArabicVerseUIEnum.both;

  @override
  void initState() {
    super.initState();
    lastSelectedArabicUI=ArabicVerseUIEnum.values[sharedPreferences.getInt(PrefConstants.arabicVerseAppearanceEnum.key)
        ??PrefConstants.arabicVerseAppearanceEnum.defaultValue];

    useArchiveListFeatures = sharedPreferences
        .getBool(PrefConstants.useArchiveListFeatures.key)??PrefConstants.useArchiveListFeatures.defaultValue;

    showListVerseIcons = sharedPreferences.getBool(PrefConstants.showVerseListIcons.key)??
        PrefConstants.showVerseListIcons.defaultValue;

  }

  void _showSavePointBottomDia(int itemIndex){
    showSelectSavePointBottomDia(context,
        parentName: pagingArgument.title,
        bookIdBinary: pagingArgument.bookIdBinary,
        itemIndexPos: itemIndex,
        originTag: pagingArgument.originTag,
        parentKey: pagingArgument.savePointArg.parentKey,
        changeLoaderListener: (savePoint) {
          setArgumentWithSavePoint(savePoint);
        });
  }

  void _execAppBarMenus(int selected) {
    switch (selected) {
      case MenuResources.fontSize:
        showSelectFontSizeBottomDia(context, listener: (fontSize) {
          customPagingController.setFontSizeEvent(fontSize.size);
        });
        break;
      case MenuResources.savePoint:
        _showSavePointBottomDia(lastIndex);
        break;
      case MenuResources.cleanSearchText:
        cleanableSearchText = null;
        rebuildItemNotifier.value = !rebuildItemNotifier.value;
        break;
    }
  }

  List<Widget> getShareListItems(VerseModel item) {
    return [
      ListTileShareItem(
          title: "Resim Olarak Payla??",
          onTap: () {
            final shareVerse =
                ShareUtils.shareImageExecutor(context, SourceTypeEnum.verse);
            showPreviewSharedImageDia(context,
                previewWidget: shareVerse.getPreviewWidget(context, item),
                onTap: () {
              shareVerse.snapshot(context, item);
            });
          },
          iconData: Icons.image),
      ListTileShareItem(
          title: "Yaz?? Olarak Payla??",
          onTap: () {
            ShareUtils.shareText(item.item, SourceTypeEnum.verse);
          },
          iconData: Icons.text_format)
    ];
  }

  void _execShowBottomMenu(VerseModel item, ListBloc listBloc) {
    showVerseBottomMenu(context,
        isFavorite: item.isFavorite,
        verse: item.item,
        isAddListNotEmpty: item.isAddListNotEmpty, listener: (verseEditEnum) {
      switch (verseEditEnum) {
        case VerseEditEnum.share:
          showShareAlertDialog(context, listItems: getShareListItems(item));
          break;
        case VerseEditEnum.addList:
          Navigator.pop(context);
          final listParam = EditSelectListModel(context: context, listCommon: item,
              favoriteListId: FavoriteListIds.verse, loader: getLoader(),
              updateArea: () {
                rebuildItems();
              });
          editSelectedLists(
              listParam,
              SelectVerseListLoader(
                  context: context, verseId: item.item.id ?? 0), false,
               changeListener: showListVerseIcons==false?null:(selectedLists){
                final anyArchive=selectedLists.any((e) => e.isArchive);
                final isNotEmptyList=selectedLists.isNotEmpty;
                var isRebuild=false;
                if(useArchiveListFeatures&&anyArchive!=item.isArchiveAddedToList){
                  item.isArchiveAddedToList=anyArchive;
                  isRebuild=true;
                }
                if(isNotEmptyList!=item.isAddListNotEmpty){
                  item.isAddListNotEmpty=isNotEmptyList;
                  isRebuild=true;
                }
                if(isRebuild){
                  rebuildItems();
                }
          });
          break;
        case VerseEditEnum.copy:
          ShareUtils.copyVerseText(item.item);
          break;
        case VerseEditEnum.addFavorite:
          final listParam = EditSelectListModel(context: context, listCommon: item,
              favoriteListId: FavoriteListIds.verse, loader: getLoader(),
              updateArea: () {
                rebuildItems();
              });
          listBloc.setLoader(SelectVerseListLoader(context: context,
            verseId: item.item.id ?? 0,
          ));
          addOrRemoveFavoriteList(listParam, listBloc, !item.isFavorite,
              reloadPagingListener: () {
            Navigator.pop(context);
          });
          break;
        case VerseEditEnum.savePoint:
          Navigator.pop(context);
          _showSavePointBottomDia(item.rowNumber);
          break;
      }
    });
  }

  @override
  Widget buildPage(BuildContext context) {


    if(pagingArgument.originTag==OriginTag.search&&
        lastSelectedArabicUI==ArabicVerseUIEnum.onlyArabic){
      lastSelectedArabicUI=ArabicVerseUIEnum.onlyMeal;
    }

    return BlocProvider(
      create: (context)=>CustomPagingBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: kResizeToAvoidBottomInset,
          backgroundColor: Theme.of(context).primaryColor,
          body: SafeArea(
            child: CustomSliverNestedView(
              context,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  CustomSliverAppBar(
                    pinned: true,
                    floating: true,
                    snap: true,
                    title: ValueListenableBuilder(
                      valueListenable: changeBarTitleNotifier,
                      builder: (context, value, child) {
                        return Text(pagingArgument.title);
                      },
                    ),
                    actions: [
                      IconButton(onPressed: (){

                        showSelectRadioEnums<ArabicVerseUIEnum>(context, currentValue:  ItemLabelModel(item: lastSelectedArabicUI, label: lastSelectedArabicUI.description),
                            radioItems: ArabicVerseUIEnum.values.map((e) => ItemLabelModel(item: e, label: e.description)).toList(),
                            closeListener: (selected)async{
                              if(selected.item!=lastSelectedArabicUI){
                                lastSelectedArabicUI=selected.item;
                                await sharedPreferences.setInt(PrefConstants.arabicVerseAppearanceEnum.key, selected.item.index);
                                rebuildItems();
                              }

                            });
                      }, icon: const Icon(Icons.view_agenda),tooltip: "G??r??n??m?? De??i??tir",),
                      IconButton(
                          onPressed: () {
                            showGetNumberBottomDia(context, (selected) {
                              customPagingController.setPageEvent(
                                  limitNumber: limitCount, itemIndex: selected);
                            }, currentIndex: lastIndex, limitIndex: itemCount - 1);
                          },
                          icon: const Icon(Icons.map)),
                      ValueListenableBuilder(
                          valueListenable: rebuildItemNotifier,
                          builder: (context, value, child) {
                            return MenuButton<int>(
                                items: getPopUpMenus(),
                                selectedFunc: (selected) {
                                  _execAppBarMenus(selected);
                                });
                          }),
                    ],
                  )
                ];
              },
              child: BlocListener<SavePointBloc, SavePointState>(
                listener: (context, state) {
                  if (state.status == DataStatus.success) {
                    final itemIndex = (state.savePoint?.itemIndexPos) ?? 0;
                    customPagingController.setPageEventWhenReady(
                        limitNumber: limitCount, itemIndex: itemIndex);
                  }
                },
                child: CustomScrollingPaging(
                    customPagingController: customPagingController,
                    loader: getLoader(),
                    buildWhen: (prevState, nextState) {
                      if (nextState.status == DataPagingStatus.setPagingSuccess) {
                        itemCount = nextState.itemCount;
                      }
                      return true;
                    },
                    itemBuilder: (context, index, item, state) {

                      if (item is VerseModel) {
                        return ValueListenableBuilder(
                            valueListenable: rebuildItemNotifier,
                            builder: (context, value, child) {
                              return VerseItem(
                                key: ObjectKey(value),
                                rowNumber: item.rowNumber,
                                arabicVerseUIEnum: lastSelectedArabicUI,
                                verseModel: item,
                                searchKey: cleanableSearchText,
                                fontSize: state.fontSize,
                                showListVerseIcons: showListVerseIcons,
                                searchCriteriaEnum: searchCriteriaEnum,
                                onLongPress: () {
                                  _execShowBottomMenu(item, listBloc);
                                },
                              );
                            });
                      }
                      return const Text("");
                    },
                    page: 1,
                    isPlaceHolderActive: true,
                    limitNumber: limitCount,
                    prevLoadingPlaceHolderCount: 1,
                    forwardValue: 3,
                    minMaxListener: (minPos, maxPos, state) {
                      lastIndex =
                          state?.items[(minPos + maxPos) ~/ 2]?.rowNumber;
                    },
                    isItemLoadingWidgetPlaceHolder: true,
                    placeHolderWidget: getVerseShimmer(context)
                ),
              ),
            ),
          )),
    );
  }


  @override
  PagingArgument getArgument() => pagingArgument;

  @override
  IPagingLoader getLoader() => pagingArgument.loader;

  @override
  void setArgument(PagingArgument newArgument) {
    pagingArgument = newArgument;
  }
}
