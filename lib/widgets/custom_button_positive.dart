import 'package:flutter/material.dart';
import 'package:hadith/utils/theme_util.dart';

class CustomButtonPositive extends StatelessWidget {
  final void Function()?onTap;
  final String? label;
  const CustomButtonPositive({Key? key, required this.onTap,this.label="Onayla"}): super(key: key);

  @override
  Widget build(BuildContext context) {

    final buttonStyle=ThemeUtil.getThemeModel(context).positiveButtonStyle();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
          onPressed: onTap,
          child: Text(label??"Onayla",style: TextStyle(
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
