import 'package:flutter/material.dart';
import 'package:hadith/themes/model/custom_button_style.dart';
import 'package:hadith/themes/model/i_theme_model.dart';

class LightModel extends IThemeModel{
  LightModel({required BuildContext context}) : super(context: context);

  @override
  Color selectedTextColor() => Colors.yellow.shade500;

  @override
  CustomButtonStyle buttonStyle2() => CustomButtonStyle(
    backgroundColor: null,
    textColor: const Color(0xff641FEF)
  );

  @override
  Color borderSideColor() => Colors.black;

  @override
  Color getVerseBaseShimmerColor() => Colors.green.shade800;

  @override
  Color getVerseHighlightShimmerColor() => Colors.green.shade700;

  @override
  Color getHadithBaseShimmerColor() => Colors.blueGrey.shade400;

  @override
  Color getHadithHighlightShimmerColor() => Colors.blueGrey.shade300;

  @override
  Color getCyanShadeColor() => Colors.greenAccent.shade200;

  @override
  Color getGreenAccentShadeColor() => Colors.cyan.shade300;

  @override
  Color getBlueShadeColor() => Colors.blue.shade700;


}