import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/bloc/visibility_bloc/visibility_bloc.dart';
import 'package:hadith/bloc/visibility_bloc/visibility_state.dart';
import 'package:hadith/constants/enums/data_paging_status_enum.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/font_size_enum.dart';
import 'package:hadith/constants/enums/sourcetype_enum.dart';
import 'package:hadith/constants/favori_list.dart';
import 'package:hadith/constants/menu_resources.dart';
import 'package:hadith/models/shimmer/shimmer_widgets.dart';
import 'package:hadith/utils/sourcetype_helper.dart';
import 'package:hadith/dialogs/show_get_number_bottom_dia.dart';
import 'package:hadith/dialogs/show_select_font_size_bottom_dia.dart';
import 'package:hadith/features/add_to_list/model/edit_select_list_model.dart';
import 'package:hadith/features/add_to_list/model/select_hadith_list_loader.dart';
import 'package:hadith/features/hadith/model/hadith_topics_model.dart';
import 'package:hadith/features/hadith/widget/hadith_scrollable_item.dart';
import 'package:hadith/features/paging/i_paging_loader.dart';
import 'package:hadith/features/paging/paging_argument.dart';
import 'package:hadith/features/save_point/bloc/save_point_bloc.dart';
import 'package:hadith/features/save_point/bloc/save_point_state.dart';
import 'package:hadith/features/save_point/show_select_savepoint_bottom_dia.dart';
import 'package:hadith/utils/share_utils.dart';
import 'package:hadith/features/share/show_preview_share_image_dia.dart';
import 'package:hadith/features/share/show_share_alert_dialog.dart';
import 'package:hadith/features/share/widget/list_tile_share_item.dart';
import 'package:hadith/features/paging/widgets/custom_scrolling_paging.dart';
import 'package:hadith/widgets/custom_sliver_appbar.dart';
import 'package:hadith/widgets/custom_sliver_nested_scrollview.dart';
import 'package:hadith/widgets/menu_button.dart';

import '../../constants/app_constants.dart';
import '../display_page_state.dart';

class HadithPageScrollable extends StatefulWidget {
  static const id = "HadithPage";
  const HadithPageScrollable({Key? key}) : super(key: key);

  @override
  State<HadithPageScrollable> createState() => _HadithPageScrollableState();
}

class _HadithPageScrollableState extends DisplayPageState<HadithPageScrollable> {
  final ValueNotifier<bool> visibilityAppBarNotifier = ValueNotifier(true);
  final ScrollController nestedViewScrollController = ScrollController();

  Timer? _timer;

  void _execAppBarMenus(int selected) {
    switch (selected) {
      case MenuResources.fontSize:
        showSelectFontSizeBottomDia(context, listener: (fontSize) {
          customPagingController.setFontSizeEvent(fontSize.size);
        });
        break;
      case MenuResources.savePoint:
        showSelectSavePointBottomDia(context,
            parentName: pagingArgument.title,
            bookIdBinary: pagingArgument.bookIdBinary,
            itemIndexPos: lastIndex,
            originTag: pagingArgument.originTag,
            parentKey: pagingArgument.savePointArg.parentKey,
            changeLoaderListener: (savePoint) {
          setArgumentWithSavePoint(savePoint);
        });
        break;
      case MenuResources.cleanSearchText:
        cleanableSearchText = null;
        rebuildItemNotifier.value = !rebuildItemNotifier.value;
        break;
    }
  }

  List<Widget> getShareListItems(HadithTopicsModel item) {
    return [
      ListTileShareItem(
          title: "Resim Olarak Paylaş",
          onTap: () {
            final shareHadith =
                ShareUtils.shareImageExecutor(context, SourceTypeEnum.hadith);
            showPreviewSharedImageDia(context,
                previewWidget: shareHadith.getPreviewWidget(context, item),
                onTap: () {
              shareHadith.snapshot(context, item);
            });
          },
          iconData: Icons.image),
      ListTileShareItem(
          title: "Yazı Olarak Paylaş",
          onTap: () {
            ShareUtils.shareText(item.item, SourceTypeEnum.hadith);
          },
          iconData: Icons.text_format),
      ListTileShareItem(
          title: "Yazıyı Kopyala",
          onTap: () {
            ShareUtils.copyHadithText(item.item);
          },
          iconData: Icons.copy)
    ];
  }

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: kResizeToAvoidBottomInset,
      body: SafeArea(
        child: CustomSliverNestedView(
          context,
          isBottomNavAffected: false,
          scrollController: nestedViewScrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              CustomSliverAppBar(
                title: ValueListenableBuilder(
                  valueListenable: changeBarTitleNotifier,
                  builder: (context, value, child) {
                    return Text(
                        "${pagingArgument.title} - ${SourceTypeHelper.getNameWithBookBinaryId(pagingArgument.bookIdBinary)}");
                  },
                ),
                pinned: true,
                actions: [
                  IconButton(
                      onPressed: () {
                        showGetNumberBottomDia(context, (selected) {
                          customPagingController.setPageEventWhenReady(
                              limitNumber: limitCount, itemIndex: selected);
                        }, currentIndex: lastIndex, limitIndex: itemCount - 1);
                      },
                      icon: const Icon(Icons.map)),
                  ValueListenableBuilder(
                    builder: (BuildContext context, value, Widget? child) {
                      return MenuButton<int>(
                          items: getPopUpMenus(),
                          selectedFunc: (selected) {
                            _execAppBarMenus(selected);
                          });
                    },
                    valueListenable: rebuildItemNotifier,
                  ),
                ],
              )
            ];
          },
          child:BlocListener<VisibilityBloc, VisibilityState>(
            listener: (context, state) {
              if (state.isVisible) {
                nestedViewScrollController.animateTo(
                  nestedViewScrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              } else {
                nestedViewScrollController.animateTo(
                    nestedViewScrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              }
            },
            child: BlocListener<SavePointBloc, SavePointState>(
              listener: (context, state) {
                if (state.status == DataStatus.success) {
                  final itemIndex = (state.savePoint?.itemIndexPos) ?? 0;
                  customPagingController.setPageEventWhenReady(
                      limitNumber: limitCount, itemIndex: itemIndex);
                }
              },
              child: CustomScrollingPaging<HadithTopicsModel>(
                buildWhen: (prevState, nextState) {
                  if (nextState.status == DataPagingStatus.setPagingSuccess) {
                    itemCount = nextState.itemCount;
                  }
                  return true;
                },
                customPagingController: customPagingController,
                loader: getLoader(),
                itemBuilder: (context, index, item, state) {
                  if (item is HadithTopicsModel) {

                    return ValueListenableBuilder(
                      builder: (context, value, child) {
                        return HadithScrollableItem(
                          key: ObjectKey(value),
                          searchCriteriaEnum: searchCriteriaEnum,
                          searchKey: cleanableSearchText,
                          hadithTopic: item,
                          fontSize: state.fontSize,
                          listIconClick: (hadithSetState) {
                            final listParam = EditSelectListModel(
                                context: context,
                                listCommon: item,
                                favoriteListId: FavoriteListIds.hadith,
                                loader: getLoader(),
                                updateArea: () {
                                  hadithSetState(() {});
                                });
                            editSelectedLists(listParam,
                                SelectHadithListLoader(context: context,
                                    hadithId: item.item.id ?? 0), true);
                          },
                          favoriteIconClick: (isFavorite, hadithSetState) {
                            final listParam = EditSelectListModel(context: context,
                                listCommon: item, favoriteListId: FavoriteListIds.hadith,
                                loader: getLoader(),
                                updateArea: () {
                                  hadithSetState(() {});
                                });
                            listBloc.setLoader(SelectHadithListLoader(context: context,
                              hadithId: item.item.id ?? 0,
                            ));
                            addOrRemoveFavoriteList(listParam, listBloc, isFavorite);
                          },
                          shareIconClick: () {
                            showShareAlertDialog(context, listItems: getShareListItems(item));
                          },
                        );
                      },
                      valueListenable: rebuildItemNotifier,
                    );
                  }
                  return const Text("");
                },
                minMaxListener: (minPos, maxPos, state) {
                  lastIndex = state?.items[(minPos + maxPos) ~/ 2].item.rowNumber;
                },
                page: 1,
                forwardValue: 2,
                limitNumber: limitCount,
                isPlaceHolderActive: true,
                isItemLoadingWidgetPlaceHolder: false,
                placeHolderCount: 1,
                placeHolderWidget: getHadithShimmer(context),
              ),
            ),
          ),
        ),
      ),
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
  @override
  void dispose() {
    _timer?.cancel();
    nestedViewScrollController.dispose();
    super.dispose();
  }
}
