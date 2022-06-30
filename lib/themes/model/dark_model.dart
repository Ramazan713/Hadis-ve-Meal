import 'package:flutter/material.dart';
import 'package:hadith/themes/model/custom_button_style.dart';

import 'package:hadith/themes/model/i_theme_model.dart';

class DarkModel extends IThemeModel{
  DarkModel({required BuildContext context}) : super(context: context);

  @override
  Color selectedTextColor() => Colors.yellow.shade900;

  @override
  CustomButtonStyle buttonStyle2() => CustomButtonStyle(
      backgroundColor: null,
      textColor: Colors.deepPurple.shade200
  );

  @override
  Color borderSideColor() => Colors.white;

  @override
  Color getVerseBaseShimmerColor() => Colors.green.shade900;

  @override
  Color getVerseHighlightShimmerColor() => Colors.green.shade800;


  @override
  Color getHadithBaseShimmerColor() => Colors.blueGrey.shade800;

  @override
  Color getHadithHighlightShimmerColor() => Colors.blueGrey.shade700;

  @override
  Color getCyanShadeColor() => Colors.green.shade700;

  @override
  Color getGreenAccentShadeColor() => Colors.cyan.shade900;

}