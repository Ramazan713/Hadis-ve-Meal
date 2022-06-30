import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hadith/widgets/custom_button1.dart';
import 'package:hadith/widgets/custom_button_positive.dart';
import 'package:hadith/dialogs/show_custom_alert_bottom_dia.dart';
import 'package:hadith/features/backup/cloud_backup_manager.dart';
import 'package:hadith/features/backup/show_cloud_download_backup_dia.dart';

void showBackup(BuildContext context,{required CloudBackupManager backupManager,
  required User user}){

  showDialog(context: context, builder: (context){
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 7),
      child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 19,vertical: 13),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(19)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.cloud),
                            const SizedBox(width: 7,),
                            Text("Bulut yedekleme",style: Theme.of(context).textTheme.headline6,)
                          ],
                        ),
                        const SizedBox(height: 29,),
                        CustomButtonPositive(onTap: (){
                          showCustomAlertBottomDia(context,title: "Devam etmek istiyor musunuz?",
                          content: "Bazı yedek dosyalarınızın değişmesine neden olabilir",btnApproved: (){
                                backupManager.uploadBackup(user);
                              });
                        },label:"Yedek Oluştur" ,),
                        const SizedBox(height: 13,),
                        CustomButtonPositive(onTap: (){
                          showDownloadBackupDia(context,cloudBackupManager: backupManager,user: user);
                        },label:"Buluttan İndir" ,),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 23,),
                CustomButton1(onTap: (){
                  Navigator.pop(context);
                },label: "Iptal",)
              ],
            ),
          ),
        ),
    );
  });
}