

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hadith/constants/enums/theme_enum.dart';
import 'package:hadith/constants/preference_constants.dart';
import 'package:hadith/themes/model/dark_model.dart';
import 'package:hadith/themes/model/i_theme_model.dart';
import 'package:hadith/themes/model/light_model.dart';
import 'package:hadith/utils/localstorage.dart';

class ThemeUtil{

  static ThemeTypesEnum getThemeEnum(){
    final sharedPreferences=LocalStorage.sharedPreferences;
    return ThemeTypesEnum.values[(sharedPreferences.getInt(PrefConstants.themeTypeEnum.key)??0)];
  }

  static ThemeMode getThemeMode(){
    ThemeTypesEnum themeTypesEnum=getThemeEnum();

    switch(themeTypesEnum){
      case ThemeTypesEnum.light:
        return ThemeMode.light;
      case ThemeTypesEnum.dark:
        return ThemeMode.dark;
      case ThemeTypesEnum.system:
        final brightness=SchedulerBinding.instance.window.platformBrightness;
        return brightness==Brightness.light?ThemeMode.light:ThemeMode.dark;
    }
  }


  static IThemeModel getThemeModel(BuildContext context){
    final result=getThemeMode();
    if(result==ThemeMode.dark){
      return DarkModel(context: context);
    }
    return LightModel(context: context);
  }




}