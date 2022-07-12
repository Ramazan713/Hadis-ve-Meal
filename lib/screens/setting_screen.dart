import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/verse_arabic_ui_enum.dart';
import 'package:hadith/dialogs/show_alert_bottom_dia_multiple_button.dart';
import 'package:hadith/dialogs/show_select_font_size_bottom_dia.dart';
import 'package:hadith/features/backup/cloud_backup_manager.dart';
import 'package:hadith/features/backup/show_backup_dia.dart';
import 'package:hadith/features/backup/user_info/bloc/user_info_bloc.dart';
import 'package:hadith/features/backup/user_info/bloc/user_info_event.dart';
import 'package:hadith/features/backup/user_info/bloc/user_info_state.dart';
import 'package:hadith/services/auth_service.dart';
import 'package:hadith/utils/share_utils.dart';
import 'package:hadith/utils/toast_utils.dart';
import 'package:hadith/widgets/custom_button_negative.dart';
import 'package:hadith/widgets/custom_button_positive.dart';
import 'package:hadith/constants/enums/search_criteria_enum.dart';
import 'package:hadith/constants/enums/theme_enum.dart';
import 'package:hadith/constants/preference_constants.dart';
import 'package:hadith/dialogs/show_custom_alert_bottom_dia.dart';
import 'package:hadith/themes/custom/get_setting_theme.dart';
import 'package:hadith/utils/theme_util.dart';
import 'package:hadith/utils/localstorage.dart';
import 'package:hadith/utils/search_criteria_helper.dart';
import 'package:hadith/dialogs/show_select_radio_enums.dart';
import 'package:hadith/models/item_label_model.dart';
import 'package:hadith/themes/bloc/theme_bloc.dart';
import 'package:hadith/themes/bloc/theme_event.dart';
import 'package:hadith/widgets/custom_sliver_appbar.dart';
import 'package:hadith/widgets/custom_sliver_nested_scrollview.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/enums/font_size_enum.dart';
import '../features/backup/show_cloud_download_backup_dia.dart';
import '../features/premium/bloc/premium_bloc.dart';
import '../features/premium/bloc/premium_state.dart';
import '../features/premium/show_premium_dia.dart';


class SettingScreen extends StatefulWidget {
  static const String id = "SettingScreen";
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  User? user;
  late ValueNotifier<SearchCriteriaEnum>notifierSearchCriteria;
  late ValueNotifier<ArabicVerseUIEnum>notifierArabicUI;

  late ValueNotifier<bool>notifierUseArchiveListFeature;
  late ValueNotifier<String>notifierFontText;

  late ThemeTypesEnum selectedThemeType;

  final SharedPreferences sharedPreferences=LocalStorage.sharedPreferences;
  


  final AuthService authService=AuthService();
  late CloudBackupManager cloudBackupManager;

  late StreamSubscription<User?> userListener;

  final ScrollController scrollController=ScrollController();

  final String packageInfo="com.masterplus.hadiths";

  void listenAuth(){
    userListener=authService.streamUser().listen((user){
      setState(() {
        this.user=user;
      });
    });

  }

  @override
  void initState() {
    listenAuth();
    super.initState();
    notifierSearchCriteria=ValueNotifier(SearchCriteriaHelper.getCriteria());
    notifierArabicUI=ValueNotifier(ArabicVerseUIEnum.values[sharedPreferences.getInt(PrefConstants.arabicVerseAppearanceEnum.key) ??
        PrefConstants.arabicVerseAppearanceEnum.defaultValue]);

    notifierUseArchiveListFeature=ValueNotifier(sharedPreferences.getBool(PrefConstants.useArchiveListFeatures.key) ??
        PrefConstants.useArchiveListFeatures.defaultValue);
    notifierFontText=ValueNotifier(FontSize.values[sharedPreferences.getInt(PrefConstants.fontSize.key) ??
        PrefConstants.fontSize.defaultValue].shortName);
  }

  Future _logOut(UserInfoBloc userInfoBloc )async{
    await cloudBackupManager.logOutRemoveFiles(user!,userInfoBloc);
    await authService.signOut(context);

  }

  void _showLogOutDialog(UserInfoBloc userInfoBloc){
    showCustomAlertBottomDia(context,
        negativeLabel: "Devam Et",
        positiveLabel: "Oluştur",
        title: "Yedekleme yapmak ister misiniz?",
        content: "Kaydedilmeyen verileriniz kaybolabilir",btnApproved: ()async{
          await cloudBackupManager.uploadAutoBackup(user!, (result) async{
            if(result){
              _logOut(userInfoBloc);
            }else{
              showCustomAlertBottomDia(context,title: "Devam etmek istiyor musunuz",
                  content: "Yedekleme işlemi başarısız oldu. Çıkış yaparsanız verileriniz kaybolabilir",
                  btnApproved: ()async{
                    _logOut(userInfoBloc);
                  }
              );
            }
          });
        },btnCancelled: ()async{
          _logOut(userInfoBloc);
        }
    );
  }

  void _showDownloadDiaForLoginFirstTime(BuildContext context,int backupMetaSize){
    if(backupMetaSize>0&&(sharedPreferences.getBool(PrefConstants.showDownloadDiaInLogin.key)??true)){
      showAlertDiaWithMultipleButton(context,
          title: "Buluttaki yedeğinizi yüklemek ister misiniz?",
          buttons: [
            CustomButtonPositive(onTap: (){
              Navigator.pop(context);
              cloudBackupManager.downloadLastBackup(user!);
            },label: "En son Yedeği Yükle",),
            CustomButtonPositive(onTap: (){
              Navigator.pop(context);
              showDownloadBackupDia(context,cloudBackupManager: cloudBackupManager,user: user!);
            },label: "Yedek dosyalarını göster",),
            CustomButtonNegative(onTap: (){
              Navigator.pop(context);
              sharedPreferences.setBool(PrefConstants.showDownloadDiaInLogin.key, false);
            },label: "Bir daha bu uyarıyı gösterme",),
            CustomButtonNegative(onTap: (){
              Navigator.pop(context);
            },label: "Iptal",),
          ]);
    }

  }



  @override
  Widget build(BuildContext context) {
    final userInfoBloc=context.read<UserInfoBloc>();

    selectedThemeType=ThemeUtil.getThemeEnum();
    cloudBackupManager=CloudBackupManager(context: context);

    if(user!=null){
      userInfoBloc.add(UserInfoEventRequest(userId: user!.uid));
    }


    return Scaffold(

      body: CustomSliverNestedView(context,
          scrollController: scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          const CustomSliverAppBar(
            title: Text("Ayarlar"),
          )
        ];
      },
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 19,),
                    BlocBuilder<UserInfoBloc,UserInfoState>(builder: (context, state) {
                      if(state.status==DataStatus.loading){
                        return const Center(child: CircularProgressIndicator(),);
                      }
                      final userInfo=state.userInfoEntity;

                      if(userInfo!=null&&userInfo.img!=null){
                        return CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 74,
                          child: CircleAvatar(
                            backgroundImage:MemoryImage(userInfo.img!,scale: 1),
                            radius: 71,
                          ),
                        );
                      }
                      return const Icon(Icons.account_circle, size: 190,);
                    }),
                    const SizedBox(height: 7,),
                    Visibility(
                        visible: (user==null),
                        child: CustomButtonPositive(
                          onTap: () async{
                              await authService.signInWithGoogle(context,successListener: ()async{
                                if(user!=null){
                                  await cloudBackupManager.logInDownloadFiles(user!,userInfoBloc,completeListener: (backupMetaSize){
                                    _showDownloadDiaForLoginFirstTime(context,backupMetaSize);
                                  });
                                }
                              });
                          },
                          label: "Giriş Yap",
                        )),
                    Visibility(
                      visible: user!=null,
                      child: Column(
                        children: [
                          Text(user?.displayName??"Boş"),
                          const SizedBox(
                            height: 7,
                          ),
                          Text(user?.email??"Boş"),
                          const SizedBox(height: 13,)
                        ],
                      ),
                    )
                  ],
                ),
                SettingsList(
                  shrinkWrap: true,
                  lightTheme: getSettingThemeData(context),
                  sections: [
                    SettingsSection(
                      title: const Text('Genel Ayarlar'),
                      tiles: [
                        SettingsTile(title: const Text("Tema Modu"),onPressed: (context)async{
                          final currentValue=ItemLabelModel(item: selectedThemeType,label: selectedThemeType.getDescription());
                          final List<ItemLabelModel<ThemeTypesEnum>> radioItems=
                          ThemeTypesEnum.values.map((e) => ItemLabelModel(item: e,label:e.getDescription())).toList();
                          showSelectRadioEnums<ThemeTypesEnum>(context,
                              currentValue: currentValue,
                              radioItems: radioItems, closeListener: (lastSelected)async{
                                if(lastSelected.item!=selectedThemeType){
                                  context.read<ThemeBloc>().add(ThemeEventChangeTheme(themeEnum: lastSelected.item));
                                  setState((){
                                    selectedThemeType=lastSelected.item;
                                  });
                                }
                              });

                        },value: Text(selectedThemeType.getDescription()),
                          leading: const Icon(Icons.palette),),

                        CustomSettingsTile(
                            child:  ValueListenableBuilder<SearchCriteriaEnum>(
                                valueListenable: notifierSearchCriteria,
                                builder: (context,selectedCriteria,child){
                                  return  SettingsTile(title: const Text("Arama Kriteri"),onPressed: (context)async{
                                    final currentValue=ItemLabelModel(item: selectedCriteria,label: selectedCriteria.getDescription());
                                    final List<ItemLabelModel<SearchCriteriaEnum>> radioItems=
                                    SearchCriteriaEnum.values.map((e) => ItemLabelModel(item: e,label:e.getDescription())).toList();
                                    showSelectRadioEnums<SearchCriteriaEnum>(context,
                                        currentValue: currentValue,
                                        radioItems: radioItems, closeListener: (lastSelected)async{
                                          await sharedPreferences.setInt(PrefConstants.searchCriteriaEnum.key, lastSelected.item.index);
                                          notifierSearchCriteria.value=lastSelected.item;
                                        });
                                  },
                                    value: Text(selectedCriteria.getDescription()),
                                    leading: const Icon(Icons.search),
                                  );
                                }
                            )
                        ),
                        CustomSettingsTile(
                          child:  ValueListenableBuilder<String>(
                              valueListenable: notifierFontText,
                              builder: (context,selectedFontText,child){
                                return SettingsTile(
                                  leading: const Icon(Icons.font_download),
                                  title: const Text("Yazı Boyutu"),
                                  onPressed: (context){
                                    showSelectFontSizeBottomDia(context, listener: (selected){
                                      notifierFontText.value=selected.shortName;
                                    });
                                  },
                                  value: Text(selectedFontText),
                                );
                              }
                          ),
                        ),

                        CustomSettingsTile(
                          child:  ValueListenableBuilder<ArabicVerseUIEnum>(
                              valueListenable: notifierArabicUI,
                              builder: (context,selectedArabicUI,child){
                                return SettingsTile(title: const Text("Ayetler Görünüm"),onPressed: (context){
                                  showSelectRadioEnums<ArabicVerseUIEnum>(context,
                                      currentValue:  ItemLabelModel(item: selectedArabicUI, label: selectedArabicUI.description),
                                      radioItems: ArabicVerseUIEnum.values.map((e) => ItemLabelModel(item: e, label: e.description)).toList(),
                                      closeListener: (selected)async{
                                        if(selected.item!=selectedArabicUI){
                                          await sharedPreferences.setInt(PrefConstants.arabicVerseAppearanceEnum.key, selected.item.index);
                                          notifierArabicUI.value=selected.item;
                                        }
                                      });
                                },leading: const Icon(FontAwesomeIcons.bookQuran),
                                  value: Text(selectedArabicUI.description),);
                              }
                          ),
                        ),
                      ],
                    ),

                    CustomSettingsSection(
                      child: BlocBuilder<PremiumBloc,PremiumState>(
                        builder: (context, state) {
                           return SettingsSection(
                             title: const Text("Premium Ayarları"),
                             tiles: [

                               CustomSettingsTile(
                                 child: Visibility(
                                   visible: !state.isPremium,
                                   child: SettingsTile.navigation(title: const Text("Premium"),onPressed: (context){
                                     showPremiumDia(context);
                                   },leading: const Icon(FontAwesomeIcons.solidChessKing),),
                                 ),
                               ),
                               CustomSettingsTile(
                                 child: Visibility(
                                  visible: state.isPremium,
                                   child:  SettingsTile(title: const Text("Abonelik Yönet"),onPressed: (context)async{
                                     final url="https://play.google.com/store/account/subscriptions?package=$packageInfo";
                                     try{
                                       await launchUrl(Uri.parse(url),mode:LaunchMode.externalApplication);
                                     }catch(e){
                                       ToastUtils.showLongToast("Bilinmeyen bir hata oluştu");
                                     }
                                   },leading: const Icon(Icons.manage_accounts),),
                                 ),
                               )
                             ],
                           );
                        },
                      )
                    ),

                    CustomSettingsSection(
                        child: Visibility(
                          visible: user!=null,
                          child: SettingsSection(
                            title: const Text("Yedekleme"),
                            tiles: [
                              SettingsTile(
                                title: const Text("Bulut Yedekleme"),
                                leading: const Icon(Icons.cloud),
                                onPressed: (context) {
                                  if(user!=null){
                                    showBackup(context,backupManager: cloudBackupManager,user: user!);
                                  }
                                },
                              ),
                            ],
                          ),
                        )
                    ),

                    SettingsSection(
                      title: const Text("Gelişmiş Ayarlar"),
                      tiles: [

                        CustomSettingsTile(
                          child:  ValueListenableBuilder<bool>(
                              valueListenable: notifierUseArchiveListFeature,
                              builder: (context,useArchiveListFeatures,child){
                                return  SettingsTile.switchTile(
                                  initialValue: useArchiveListFeatures,
                                  onToggle: (newValue)async{
                                    await sharedPreferences.setBool(PrefConstants.useArchiveListFeatures.key,newValue);
                                    notifierUseArchiveListFeature.value=newValue;
                                  }
                                  , title: const Text("Arşivdeki listeleri, liste seçmede ve eklemede kullan"),
                                );
                              }
                          ),
                        ),


                        SettingsTile(title: const Text("Varsayılan ayarlara dön"),onPressed: (context){
                            showCustomAlertBottomDia(context,title: "Varsayılan ayarlara dönmek istediğinize emin misiniz?",
                            btnApproved: ()async{
                              await PrefConstants.setDefaultValues();
                              context.read<ThemeBloc>().add(ThemeEventChangeTheme(themeEnum: ThemeUtil.getThemeEnum()));
                              setState(() {});
                            });
                        },leading: const Icon(Icons.settings_backup_restore),),
                        SettingsTile(title:const Text("Tüm verileri Sil"),onPressed: (context){
                          showCustomAlertBottomDia(context,title: "Devam etmek istiyor musunuz?",
                          content: "Tüm verileriniz silinecektir. Bu işlem geri alınamaz",btnApproved: ()async{
                                await cloudBackupManager.deleteAllData(context,listener: (){
                                  ToastUtils.showLongToast("Başarıyla Silindi");
                                });
                              });
                        },leading: const Icon(Icons.delete_forever),)
                      ],
                    ),

                    SettingsSection(
                      title: const Text('Uygulama'),
                      tiles: [
                        SettingsTile(
                          title: const Text('Uygulamayı Paylaş'),
                          leading: const Icon(Icons.share),
                          onPressed: (context) {
                            final url="https://play.google.com/store/apps/details?id=$packageInfo";
                            ShareUtils.shareContent(url);
                          },
                        ),
                        SettingsTile(
                          title: const Text('Uygulamayı Derecelendir'),
                          leading: const Icon(Icons.star_rate),
                          onPressed: (context) async{
                            final url="https://play.google.com/store/apps/details?id=$packageInfo";
                            try{
                              await launchUrl(Uri.parse(url),mode:LaunchMode.externalApplication);
                            }catch(e){
                              ToastUtils.showLongToast("Bilinmeyen bir hata oluştu");
                            }
                          },
                        ),
                      ],
                    ),


                    CustomSettingsSection(
                      child: Visibility(
                        visible: user!=null,
                        child: SettingsTile(
                          title: const Center(
                              child: Text(
                                "Çıkış Yap",
                                style: TextStyle(color: Colors.redAccent),
                              )),
                          onPressed: (context) {
                            showCustomAlertBottomDia(context,
                                title: "Çıkış yapmak istediğinize emin misiniz?",
                                btnApproved: ()async{
                                  _showLogOutDialog(userInfoBloc);
                                });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
  @override
  void dispose(){
    userListener.cancel();
    super.dispose();
  }

}
