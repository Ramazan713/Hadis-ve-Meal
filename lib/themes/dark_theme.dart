import 'package:flutter/material.dart';
import 'package:hadith/themes/theme_constants.dart';

ThemeData getDarkThemeData() {
  return ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(

      backgroundColor: Colors.green,
      iconTheme: kIconThemeData.copyWith(color: kDefaultDarkTextColor),
      titleTextStyle: const TextStyle(
        fontSize: 19,
        color: Colors.white,
        fontWeight: FontWeight.w500
      )
    ),
    iconTheme: kIconThemeData.copyWith(color: kDefaultDarkTextColor),
    primaryColorLight: Colors.greenAccent.shade700,
    primaryColor: Colors.green.shade700,
    primaryColorDark: Colors.green.shade900,
    errorColor: Colors.redAccent.shade700,
    selectedRowColor: Colors.cyan.shade900,
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(Colors.blue.shade700)
    ),
    cardColor: Colors.grey.shade800,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green).copyWith(
        secondary: Colors.teal.shade900,
        primary: Colors.green.shade700),
    textButtonTheme: kTextButtonTheme,
    floatingActionButtonTheme: kFloatingThemeData.copyWith(
        backgroundColor: Colors.indigoAccent.shade700),
    inputDecorationTheme: kInputDecorationTheme.copyWith(
        fillColor: Colors.black,
        iconColor: Colors.black,
        suffixIconColor: Colors.white,
        focusedBorder: kInputBorder.copyWith(
          borderSide: BorderSide(color: Colors.blue.shade700),
        ),
        border: kInputBorder.copyWith(
          borderSide: BorderSide(color: Colors.blue.shade700),
        )),
    tabBarTheme: kTabBarTheme,
    textTheme: const TextTheme(
      headline5:
          TextStyle(color: kDefaultDarkTextColor, fontWeight: FontWeight.w700),
      headline6: TextStyle(color: kDefaultDarkTextColor),
      bodyText1: TextStyle(
          color: kDefaultDarkTextColor,
          fontSize: 17,
          fontWeight: FontWeight.w400),
      bodyText2: TextStyle(color: kDefaultDarkTextColor, fontSize: 15),
      subtitle1: TextStyle(color: kDefaultDarkTextColor),
    ),
  );
}
