
import 'package:flutter/material.dart';

class ListTileShareItem extends StatelessWidget {
  final Function()onTap;
  final String title;
  final IconData iconData;
  const ListTileShareItem({Key? key,required this.title,required this.onTap,
    required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyText1Style=Theme.of(context).textTheme.bodyText1;
    return  Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(onTap: onTap,tileColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
        leading: Icon(iconData,color: bodyText1Style?.color,),title: Text(title,style: bodyText1Style,),),
    );
  }
}
