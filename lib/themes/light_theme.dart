import 'package:flutter/material.dart';
import 'package:hadith/themes/theme_constants.dart';


ThemeData getLightThemeData() {
  return ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.grey.shade200,
      iconTheme: kIconThemeData.copyWith(color: Colors.black),
      primaryColorLight: Colors.greenAccent,
      primaryColor: Colors.green,
      primaryColorDark: Colors.green.shade700,
      errorColor: Colors.redAccent,
      selectedRowColor: Colors.cyan.shade300,
      cardColor: Colors.grey.shade300,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(
          secondary: Colors.teal.shade200),
      textButtonTheme: kTextButtonTheme,
      floatingActionButtonTheme:
          kFloatingThemeData.copyWith(backgroundColor: Colors.indigoAccent),
      inputDecorationTheme: kInputDecorationTheme.copyWith(
          fillColor: Colors.white,
          iconColor: Colors.white,
          suffixIconColor: Colors.black,
          focusedBorder: kInputBorder.copyWith(
            borderSide: const BorderSide(color: Colors.blue),
          ),
          border: kInputBorder.copyWith(
            borderSide: const BorderSide(color: Colors.blue),
          )),
      tabBarTheme: kTabBarTheme,
      textTheme: const TextTheme(
        headline5: TextStyle(
            color: kDefaultLightTextColor, fontWeight: FontWeight.w700),
        headline6: TextStyle(color: kDefaultLightTextColor),
        headline4: TextStyle(color: kDefaultLightTextColor),
        bodyText1: TextStyle(
            color: kDefaultLightTextColor,
            fontSize: 17,
            fontWeight: FontWeight.w400),
        bodyText2: TextStyle(color: kDefaultLightTextColor, fontSize: 15),
        subtitle1: TextStyle(color: kDefaultLightTextColor),
      ));
}
