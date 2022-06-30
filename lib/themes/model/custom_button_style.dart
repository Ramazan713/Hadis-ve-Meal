

import 'package:flutter/material.dart';

class CustomButtonStyle{
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color? backgroundColor;

  CustomButtonStyle({this.fontSize=17,this.fontWeight=FontWeight.w500,this.textColor=Colors.black,
    this.backgroundColor=Colors.greenAccent});

  CustomButtonStyle copyWith({double? fontSize,FontWeight? fontWeight,Color? textColor,
    Color? backgroundColor}){
    return CustomButtonStyle(
      fontSize: fontSize??this.fontSize,
      fontWeight: fontWeight??this.fontWeight,
      backgroundColor: backgroundColor??this.backgroundColor,
      textColor: textColor??this.textColor
    );
  }
}

