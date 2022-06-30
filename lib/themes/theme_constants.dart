import 'package:flutter/material.dart';

const kDefaultLightTextColor=Colors.black;
const kDefaultDarkTextColor=Colors.white70;


const kIconThemeData=IconThemeData(
    color: Colors.white
);

const kTabBarTheme=TabBarTheme(
    labelStyle: TextStyle(
        fontSize: 17
    )
);

final kTextButtonTheme=  TextButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 19)),
      shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13)))),
    )
);

const kFloatingThemeData=FloatingActionButtonThemeData(
    backgroundColor: Colors.indigoAccent
);

final kInputBorder=OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.blue),
    borderRadius: BorderRadius.circular(13));

final kInputDecorationTheme=InputDecorationTheme(
  fillColor: Colors.white,
  isCollapsed: false,
  filled: true,
  isDense: true,
  iconColor: Colors.white,
  suffixIconColor: Colors.black,
  focusedBorder: kInputBorder,
  contentPadding: const EdgeInsets.symmetric(horizontal: 19, vertical: 13),
  border:kInputBorder,
);