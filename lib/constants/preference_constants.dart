

import 'package:hadith/constants/enums/font_size_enum.dart';
import 'package:hadith/constants/enums/search_criteria_enum.dart';
import 'package:hadith/constants/enums/theme_enum.dart';
import 'package:hadith/constants/enums/verse_arabic_ui_enum.dart';
import 'package:hadith/utils/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/key_type_model.dart';
import 'enums/scope_filter_enum.dart';

class PrefConstants{

  static KeyTypeModel fontSize=KeyTypeModel<int>( key: "fontSize",defaultValue: FontSize.medium.index);
  static KeyTypeModel searchCriteriaEnum=KeyTypeModel<int>( key: "searchCriteriaEnum",defaultValue: SearchCriteriaEnum.multipleKeys.index);
  static KeyTypeModel scopeFilterEnum=KeyTypeModel<int>(key: "scopeFilterEnum",defaultValue: ScopeFilterEnum.scope.index);
  static KeyTypeModel themeTypeEnum=KeyTypeModel<int>( key: "themeTypeEnum",defaultValue: ThemeTypesEnum.system.index);
  static KeyTypeModel counterBackupDate=const KeyTypeModel<String>( key: "counterBackupDate",defaultValue: "");
  static KeyTypeModel useArchiveListFeatures=const KeyTypeModel<bool>(key: "useArchiveListFeatures",defaultValue: false);
  static KeyTypeModel showVerseListIcons=const KeyTypeModel<bool>(key: "showVerseListIcons",defaultValue: false);

  static KeyTypeModel showDownloadDiaInLogin=const KeyTypeModel<bool>(key: "showDownloadDiaInLogin", defaultValue: true);
  static KeyTypeModel arabicVerseAppearanceEnum=KeyTypeModel<int>(key: "arabicVerseAppearanceEnum", defaultValue: ArabicVerseUIEnum.both.index);



  static List<KeyTypeModel>values()=>[fontSize,searchCriteriaEnum,useArchiveListFeatures,showVerseListIcons,
    scopeFilterEnum,themeTypeEnum,counterBackupDate,showDownloadDiaInLogin,arabicVerseAppearanceEnum];


  static Future<void>setDefaultValues()async{
    final SharedPreferences _sharedPref=LocalStorage.sharedPreferences;

    for(var item in values()){
      switch(item.type){
        case int:
          await _sharedPref.setInt(item.key, item.defaultValue);
          break;
        case String:
          await _sharedPref.setString(item.key, item.defaultValue);
          break;
        case bool:
          await _sharedPref.setBool(item.key, item.defaultValue);
          break;
        case double:
          await _sharedPref.setDouble(item.key, item.defaultValue);
          break;
        case List<String>:
          await _sharedPref.setStringList(item.key, item.defaultValue);
          break;
      }
    }

  }

}