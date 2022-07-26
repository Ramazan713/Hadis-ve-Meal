import 'package:flutter/material.dart';

import 'custom_button_style.dart';

abstract class IThemeModel{
  final BuildContext context;
  IThemeModel({required this.context});

  Color selectedTextColor();

  Color borderSideColor();

  Color getVerseBaseShimmerColor();
  Color getVerseHighlightShimmerColor();

  Color getHadithBaseShimmerColor();
  Color getHadithHighlightShimmerColor();

  Color getCyanShadeColor();

  Color getBlueShadeColor();

  Color getGreenAccentShadeColor();


  CustomButtonStyle positiveButtonStyle() => CustomButtonStyle(
    backgroundColor: Theme.of(context).primaryColorLight,
  );

  CustomButtonStyle negativeButtonStyle() => CustomButtonStyle(
    backgroundColor: Theme.of(context).errorColor,
  );

  CustomButtonStyle buttonStyle2();

}