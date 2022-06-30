import 'package:flutter/material.dart';


class IconTextItem extends StatelessWidget {
  final String title;
  final void Function() onTap;
  final IconData iconData;
  Color? _iconColor;
  IconTextItem({Key? key,required this.title,
    required this.iconData,required this.onTap,Color? iconColor})
      : super(key: key){
    _iconColor=iconColor;
  }

  @override
  Widget build(BuildContext context) {
    _iconColor=_iconColor??Theme.of(context).iconTheme.color;
    return Card(
      elevation: 0,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListTile(
        leading: Icon(iconData,color: _iconColor,),
        dense: true,
        contentPadding: const EdgeInsets.only(left: 20,top: -23,bottom: -23),
        title: Text(
          title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        onTap: onTap,
      ),

    );
  }
}
