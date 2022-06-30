import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/dialogs/edit_text_bottom_dia.dart';
import 'package:hadith/dialogs/show_custom_alert_bottom_dia.dart';
import 'package:hadith/features/add_to_list/bloc/list_bloc.dart';
import 'package:hadith/features/add_to_list/bloc/list_event.dart';
import 'package:hadith/features/add_to_list/bloc/list_state.dart';
import 'package:hadith/widgets/custom_button_positive.dart';
import 'package:hadith/features/add_to_list/model/i_select_list_loader.dart';
import 'package:hadith/features/add_to_list/widget/select_list_item.dart';
import 'package:hadith/utils/toast_utils.dart';
import 'package:hadith/widgets/icon_text_button_side.dart';

void showSelectListBottomDia(BuildContext context,
    {required ISelectListLoader listLoader, int? parentListId,
    void Function(bool isAnyChange, List<int> selectedIds)? anyChange,
    bool includeFavoriteList = true}) async {

  var isAnyChange = false;
  var selectedListIds = <int>[];
  final ScrollController scrollController = ScrollController();

  void callListener() {
    anyChange?.call(isAnyChange, selectedListIds);
  }

  void popBack(BuildContext context) {
    Navigator.pop(context);
  }

  Widget getEmptyWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.library_add,
          size: 70,
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          "Yeni listeler ekleyin",
          style: Theme.of(context).textTheme.headline6,
        )
      ],
    );
  }

  await showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        var bloc = context.read<ListBloc>();
        bloc.setLoader(listLoader);
        bloc.add(
            SelectListEventRequested(includeFavoriteList: includeFavoriteList));

        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            void addToList(int listId) {
              setState(() {
                selectedListIds.add(listId);
                bloc.add(ListEventAddToList(listId: listId));
                isAnyChange = true;
              });
            }

            void removeToList(int listId) {
              setState(() {
                selectedListIds.remove(listId);
                bloc.add(ListEventRemoveToList(listId: listId));
                isAnyChange = true;
              });
            }

            void editList(int listId, bool isSelected) async {
              if (isSelected) {
                addToList(listId);
              } else {
                if (listId == parentListId) {
                  showCustomAlertBottomDia(context,
                      title: "Listeden kaldırmak istediğinize emin misiniz?",
                      content: "Bulunduğunuz listeyi etkileyecektir",
                      btnApproved: () {
                    removeToList(listId);
                  });
                } else {
                  removeToList(listId);
                }
              }
            }

            return DraggableScrollableSheet(
              minChildSize: 0.2,
              expand: false,
              builder: (context, scrollControllerDraggable) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        shrinkWrap: true,
                        controller: scrollControllerDraggable,
                        slivers: [
                          SliverList(
                            delegate: SliverChildListDelegate([
                              const SizedBox(
                                height: 7,
                              ),
                              Text(
                                "Liste Seçin",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              const SizedBox(
                                height: 13,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13, vertical: 7),
                                  child: IconTextButtonSide(
                                    iconData: Icons.add,
                                    title: "Liste Ekle",
                                    onPress: () {
                                      showEditTextBottomDia(context, (label) {
                                        bloc.add(
                                            ListEventFormNewList(label: label));
                                        ToastUtils.showLongToast("Başarılı");
                                      }, title: "Liste ismi giriniz");
                                    },
                                  )),
                              BlocBuilder<ListBloc, ListState>(
                                builder: (context, state) {
                                  selectedListIds = state.selectedListIds;
                                  final itemLen = state.allList.length;
                                  if (state.status == DataStatus.loading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }

                                  if (itemLen == 0) {
                                    return Center(
                                        child: getEmptyWidget(context));
                                  }

                                  return ListView.builder(
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      var item = state.allList[index];
                                      final isSelected =
                                          selectedListIds.contains(item.id);
                                      return SelectListItem(
                                        isParentList: item.id == parentListId,
                                        isSelected: isSelected,
                                        item: item,
                                        listener: (isSelected) {
                                          editList(item.id ?? 0, isSelected);
                                        },
                                      );
                                    },
                                    itemCount: itemLen,
                                  );
                                },
                              ),
                            ]),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Colors.black,
                    ),
                    CustomButtonPositive(onTap: () {
                      popBack(context);
                    }),
                  ],
                );
              },
            );
          },
        );
      }).whenComplete(() {
    callListener();
  });
}
