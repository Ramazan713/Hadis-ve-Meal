import 'package:flutter/material.dart';
import 'package:hadith/constants/app_constants.dart';

class HomeSubItem extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final IconData iconData;

  const HomeSubItem({Key? key,required this.onTap,required this.title,required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle=Theme.of(context).textTheme.headline6;
    final color=kIsTextBlackWithLightPrimary?
      Colors.black:textStyle?.color;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: ListTile(
        onTap: onTap,
        horizontalTitleGap: 0,
        minVerticalPadding: 20,
        minLeadingWidth: 0,
        contentPadding: const EdgeInsets.only(left: 30,right: 30),
        tileColor: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19),
          side: BorderSide(width: 0.3,color: color??Colors.black)),
        leading: Icon(iconData,size: 30,color: color,),
        title: Text(title,textAlign: TextAlign.center,
          style: textStyle?.copyWith(
            fontWeight: FontWeight.w400,
            color: color
          ),),
      ),
    );
  }
}
