import 'package:flutter/material.dart';

import '../utils/theme_util.dart';

class CustomButtonNegative extends StatelessWidget {
  final void Function()?onTap;
  final String? label;
  const CustomButtonNegative({Key? key,required this.onTap,this.label="Iptal"}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle=ThemeUtil.getThemeModel(context).negativeButtonStyle();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
          onPressed: onTap,
          child: Text(label??"Iptal",style: TextStyle(
              fontSize: buttonStyle.fontSize,
              fontWeight: buttonStyle.fontWeight,
              color: buttonStyle.textColor
          ),),
          style: Theme.of(context).textButtonTheme.style?.copyWith(
              backgroundColor: MaterialStateProperty.all(buttonStyle.backgroundColor)
          )
      ),
    );
  }
}
