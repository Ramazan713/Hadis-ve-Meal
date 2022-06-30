import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/widgets/custom_button_positive.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/constants/enums/scope_filter_enum.dart';
import 'package:hadith/constants/preference_constants.dart';
import 'package:hadith/constants/save_point_constant.dart';
import 'package:hadith/utils/localstorage.dart';
import 'package:hadith/utils/sourcetype_helper.dart';
import 'package:hadith/db/entities/savepoint.dart';
import 'package:hadith/dialogs/edit_text_bottom_dia.dart';
import 'package:hadith/dialogs/show_custom_alert_bottom_dia.dart';
import 'package:hadith/features/save_point/bloc/save_point_edit_bloc.dart';
import 'package:hadith/features/save_point/bloc/save_point_edit_event.dart';
import 'package:hadith/features/save_point/widget/save_point_bloc_runner.dart';
import 'package:hadith/utils/toast_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/save_point_bloc.dart';
import 'bloc/save_point_event.dart';

void showSelectSavePointBottomDia(BuildContext context,
    {required OriginTag originTag,
    required String parentKey,
    required int itemIndexPos,
    required String parentName,
    required int bookIdBinary,
    required void Function(SavePoint savePoint) changeLoaderListener}) async {

  final ValueNotifier<SavePoint?> selectedNotifier = ValueNotifier(null);

  final ValueNotifier<ScopeFilterEnum> selectedFilterNotifier =
      ValueNotifier(ScopeFilterEnum.scope);

  final SharedPreferences sharedPreferences = LocalStorage.sharedPreferences;

  final isScopeOrigin = kSavePointScopeOrigins.contains(originTag);
  final ScrollController scrollController=ScrollController();


  final editPointBloc = context.read<SavePointEditBloc>();

  ScopeFilterEnum getSharedScopeFilter() {
    return ScopeFilterEnum.values[
        sharedPreferences.getInt(PrefConstants.scopeFilterEnum.key) ?? 0];
  }

  bool isScopeSavePoint(SavePoint savepoint) {
    return isScopeOrigin && savepoint.parentKey != parentKey;
  }

  List<DropdownMenuItem<ScopeFilterEnum>> getDropDownItems() {
    List<DropdownMenuItem<ScopeFilterEnum>> menuItems = [];

    for (var item in ScopeFilterEnum.values) {
      menuItems.add(DropdownMenuItem(
        child: Text(item.getDescription()),
        value: item,
      ));
    }

    return menuItems;
  }

  void requestLoadData() {
    editPointBloc.add(SavePointEditEventRequest(
        scopeFilter: isScopeOrigin ? selectedFilterNotifier.value : null,
        parentKey: parentKey,
        originTag: originTag,
        bookIdBinary: bookIdBinary));
  }

  void overrideSavePoint(SavePoint selectedSavePoint) {
    editPointBloc.add(SavePointEditEventOverride(
        newSavePoint: selectedSavePoint.copyWith(
            itemIndexPos: itemIndexPos,
            parentName: parentName,
            parentKey: parentKey)));
    ToastUtils.showLongToast("Üzerine Yazıldı");
  }

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        selectedFilterNotifier.value = getSharedScopeFilter();

        requestLoadData();

        return DraggableScrollableSheet(
          minChildSize: 0.2,
          initialChildSize: 0.5,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollControllerDraggable) {
            return  Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: scrollControllerDraggable,
                    shrinkWrap: true,
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate([
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                isScopeOrigin ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 13),
                                  child: ValueListenableBuilder<
                                      ScopeFilterEnum>(
                                      valueListenable: selectedFilterNotifier,
                                      builder: (context, value, child) {
                                        return DropdownButton<
                                            ScopeFilterEnum>(
                                            items: getDropDownItems(),
                                            value: value,
                                            onChanged: (selectedValue) {
                                              if (selectedValue != null) {
                                                sharedPreferences.setInt(
                                                    PrefConstants.scopeFilterEnum.key,
                                                    selectedValue.index);
                                                selectedFilterNotifier.value = selectedValue;
                                                requestLoadData();
                                              }
                                            });
                                      }),
                                )
                                    : const SizedBox(),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      size: 27,
                                    ))
                              ],
                            ),
                            Text("Kayıt Noktaları",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline6),
                            const SizedBox(
                              height: 13,
                            ),
                            CustomButtonPositive(
                              onTap: () {
                                final date = DateTime.now();
                                final typeDescription =
                                SourceTypeHelper.getNameWithBookBinaryId(
                                    bookIdBinary);
                                final wideSavePointScope =
                                kSavePointScopeOrigins.contains(originTag);
                                final title = SavePoint.getAutoTitle(parentName, typeDescription,
                                    date.toString(), false, wideSavePointScope, originTag.shortName);

                                showEditTextBottomDia(context, (newTitle) {
                                  editPointBloc.add(SavePointEditEventInsert(
                                      itemIndexPos: itemIndexPos,
                                      originTag: originTag,
                                      parentName: parentName,
                                      title: newTitle,
                                      dateTime: date,
                                      bookIdBinary: bookIdBinary,
                                      parentKey: parentKey));
                                  ToastUtils.showLongToast(
                                      "Yeni Kayıt Oluşturuldu");
                                }, title: "Başlık Girin", content: title);
                              },
                              label: "Yeni kayıt oluştur",
                            ),
                            SavePointBlocRunner(
                                scrollController: scrollController,
                                showOriginText: false,
                                selectedNotifier: selectedNotifier),
                          ])),
                    ],
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: CustomButtonPositive(
                        onTap: () {
                          final savePoint = selectedNotifier.value;
                          if (savePoint != null) {
                            final selectedId =
                                selectedNotifier.value?.id;

                            if (isScopeSavePoint(savePoint)) {
                              showCustomAlertBottomDia(context,
                                  content:
                                  "Yeni bir cüz'e geçmek istediğinize emin misiniz",
                                  btnApproved: () {
                                    changeLoaderListener.call(savePoint);
                                    Navigator.pop(context);
                                  });
                            } else {
                              final savePointBloc =
                              context.read<SavePointBloc>();
                              savePointBloc.add(
                                  SavePointEventRequestWithId(
                                      savePointId: selectedId));
                              Navigator.pop(context);
                            }
                          }
                        },
                        label: "Yükle",
                      ),
                    ),
                    Expanded(
                      child: CustomButtonPositive(
                        onTap: () {
                          final selectedSavePoint =
                              selectedNotifier.value;
                          if (selectedSavePoint != null) {
                            if (isScopeSavePoint(selectedSavePoint)) {
                              showCustomAlertBottomDia(context,
                                  content:
                                  "Farklı bir cüz'ün üzerine yazmak istediğinize emin misiniz",
                                  btnApproved: () {
                                    overrideSavePoint(selectedSavePoint);
                                  });
                            } else {
                              overrideSavePoint(selectedSavePoint);
                            }
                          }
                        },
                        label: "Üzerine Yaz",
                      ),
                    )
                  ],
                )
              ],
            );
          },
        );
      });
}
