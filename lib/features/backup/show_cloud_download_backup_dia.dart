import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/dialogs/show_custom_alert_bottom_dia.dart';
import 'package:hadith/widgets/custom_button_negative.dart';
import 'package:hadith/widgets/custom_button_positive.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/preference_constants.dart';
import 'package:hadith/db/entities/backup_meta.dart';
import 'package:hadith/features/backup/backup_meta/bloc/backup_meta_event.dart';
import 'package:hadith/features/backup/backup_meta/bloc/backup_meta_state.dart';
import 'package:hadith/features/backup/cloud_backup_manager.dart';
import 'package:hadith/utils/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/app_constants.dart';
import 'backup_meta/bloc/backup_meta_bloc.dart';

void showDownloadBackupDia(BuildContext context,
    {required CloudBackupManager cloudBackupManager, required User user}) {
  final ValueNotifier<String> _counter = ValueNotifier("");
  final ValueNotifier<BackupMeta?> _selectedItem = ValueNotifier(null);
  final ValueNotifier<bool> _disabledRefresh = ValueNotifier(false);
  final SharedPreferences sharedPreferences = LocalStorage.sharedPreferences;

  final ScrollController _scrollController=ScrollController();


  void callTimer() {
    final dateText = sharedPreferences.getString(PrefConstants.counterBackupDate.key) ?? "";

    if (dateText != "") {
      final DateTime? prevDate = DateTime.tryParse(dateText);
      if (prevDate != null) {
        final diffSeconds = DateTime.now().difference(prevDate).inSeconds;
        if (diffSeconds <= kWaitingRefreshTime) {
          final longSeconds = kWaitingRefreshTime - diffSeconds;
          _disabledRefresh.value = true;
          Timer.periodic(const Duration(seconds: 1), (timer) {
            final value = longSeconds - timer.tick;
            if (value == 0) {
              timer.cancel();
              _disabledRefresh.value = false;
              _counter.value = "";
            } else {
              _counter.value = "$value";
            }
          });
        }
      }
    }
  }

  callTimer();

  showDialog(
      context: context,
      builder: (context) {
        final bodyText1Style = Theme.of(context).textTheme.bodyText1;

        final BackupMetaBloc backupMetaBloc = context.read<BackupMetaBloc>();
        backupMetaBloc.add(BackupMetaEventRequest());

        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 7),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 13),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_download),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(
                        "Buluttan ??ndir",
                        style: Theme.of(context).textTheme.headline6,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ValueListenableBuilder(
                          valueListenable: _counter,
                          builder: (context, value, child) {
                            return Text(
                              "$value",
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                      color: Theme.of(context).errorColor),
                            );
                          }),
                      const SizedBox(width: 7,),
                      ValueListenableBuilder(
                          valueListenable: _disabledRefresh,
                          builder: (context, value, child) {
                            return IconButton(
                              onPressed: value == true ? null : () async {
                                      backupMetaBloc.add(BackupMetaEventLoadingState());
                                      sharedPreferences.setString(PrefConstants.counterBackupDate.key,
                                          DateTime.now().toIso8601String());
                                      callTimer();
                                      await cloudBackupManager.refreshFiles(user);
                                      backupMetaBloc.add(BackupMetaEventSuccessState());
                                    },
                              icon: const Icon(
                                Icons.refresh,
                                size: 30,
                              ),
                              tooltip: "G??ncel olmad??????n?? d??????n??yorsan??z t??klay??n",
                            );
                          }),
                      const SizedBox(
                        width: 3,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  BlocBuilder<BackupMetaBloc, BackupMetaState>(
                      builder: (context, state) {
                    if (state.status == DataStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final items = state.backupMetas;

                    if (items.isEmpty) {
                      return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 23),
                          child: Text(
                            "Herhangi bir veri bulunamad??",
                            textAlign: TextAlign.center,
                          ));
                    }

                    return ListView.builder(
                      controller: _scrollController,
                        itemBuilder: (context, index) {
                          final item = items[index];

                          return ValueListenableBuilder<BackupMeta?>(
                              valueListenable: _selectedItem,
                              builder: (context, value, child) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    tileColor: value == item ? Theme.of(context).selectedRowColor : null,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(19),
                                        side: BorderSide(
                                            color: bodyText1Style?.color ?? Colors.black)),
                                    title: Text(
                                      "Backup-${item.isAuto ? 'Auto-' : ''}${item.updatedDate}",
                                      style: bodyText1Style,
                                    ),
                                    onTap: () {
                                      _selectedItem.value = item;
                                    },
                                  ),
                                );
                              });
                        },
                        itemCount: items.length,
                        shrinkWrap: true);
                  }),
                  const SizedBox(
                    height: 13,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [


                      CustomButtonPositive(onTap: () async {
                        if (_selectedItem.value != null) {
                          showCustomAlertBottomDia(context,
                              title: "Devam etmek istiyor musunuz? (??zerine Yaz)",
                              content:
                                  """Yerelde bulunan verileriniz silinip buluttaki verileriniz y??klenecektir.(Yerelde kaydedilmemi?? verileriniz varsa veri kayb??na neden olabilir)""",
                              btnApproved: () async {
                            cloudBackupManager.downloadFile(
                                _selectedItem.value!.fileName, user,true);
                          });
                        }
                      },label: "??zerine Yaz",),
                      CustomButtonPositive(onTap: () {
                        if (_selectedItem.value != null) {
                          showCustomAlertBottomDia(context,
                              title: "Devam etmek istiyor musunuz? (??zerine Ekle)",
                              content:
                              """Yerelde bulunan verileriniz silinmeyecektir ama ??zerine eklenece??i i??in veri de??i??ikli??ine, gereksiz veri fazlal??????na veya veri kayb??na neden olabilir""",
                              btnApproved: () async {
                                cloudBackupManager.downloadFile(
                                    _selectedItem.value!.fileName, user,false);
                              });
                        }
                      }, label: "??zerine Ekle",),
                      CustomButtonNegative(onTap: () {
                        Navigator.pop(context);
                      }),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
}
