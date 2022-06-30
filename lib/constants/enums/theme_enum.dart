

import 'package:flutter/material.dart';

enum ThemeTypesEnum{
  system,dark,light
}

extension ThemeEnumExtension on ThemeTypesEnum{
  ThemeMode get mode{
    switch(this){
      case ThemeTypesEnum.system:
        return ThemeMode.system;
      case ThemeTypesEnum.dark:
        return ThemeMode.dark;
      case ThemeTypesEnum.light:
        return ThemeMode.light;
    }
  }

  String getDescription(){
    switch(this){
      case ThemeTypesEnum.system:
        return "Sistem";
      case ThemeTypesEnum.dark:
        return "Karanlık";
      case ThemeTypesEnum.light:
        return "Aydınlık";
    }
  }

}