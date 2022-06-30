

import 'package:flutter/material.dart';

class IconTextButtonSide extends StatelessWidget {
  final void Function()?onPress;
  final String title;
  final IconData iconData;
  const IconTextButtonSide({Key? key,required this.iconData,required this.title,
    required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: Theme.of(context).textButtonTheme.style?.copyWith(
          side: MaterialStateProperty.all(BorderSide(color:Theme.of(context).textTheme.subtitle1?.color??Colors.black))
      ),
      onPressed:onPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            color: Theme.of(context).textTheme.subtitle1?.color,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}
