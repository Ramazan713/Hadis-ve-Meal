

import 'package:flutter/material.dart';

import '../utils/theme_util.dart';

class CustomButton1 extends StatelessWidget {
  final void Function()?onTap;
  final String label;
  const CustomButton1({Key? key, required this.onTap,this.label="Onayla"}): super(key: key);

  @override
  Widget build(BuildContext context) {

    final buttonStyle=ThemeUtil.getThemeModel(context).buttonStyle2();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
          onPressed: onTap,
          child: Text(label,style: TextStyle(
              fontSize: buttonStyle.fontSize,
              fontWeight: buttonStyle.fontWeight,
              color: buttonStyle.textColor
          ),),
          style: Theme.of(context).textButtonTheme.style?.copyWith(
              backgroundColor: MaterialStateProperty.all(buttonStyle.backgroundColor),
              overlayColor: MaterialStateProperty.all(buttonStyle.textColor.withOpacity(0.1))
          )
      ),
    );
  }
}