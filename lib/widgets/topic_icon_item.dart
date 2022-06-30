


import 'package:flutter/material.dart';

class TopicIconItem extends StatelessWidget {
  final String label;
  final IconData iconData;
  final void Function()?onTap;
  final void Function()?onLongPress;
  final Widget? trailing;
  const TopicIconItem({Key? key,required this.label,this.onLongPress,required this.iconData,this.trailing,
    required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle=Theme.of(context).textTheme.bodyText1;
    return Card(
        color: Theme.of(context).colorScheme.secondary,
        child: ListTile(
          title: Text(label,style: textStyle,),
          leading: Icon(iconData,color: textStyle?.color,),
          onTap: onTap,
          onLongPress: onLongPress,
          trailing: trailing,
        ));
  }
}
