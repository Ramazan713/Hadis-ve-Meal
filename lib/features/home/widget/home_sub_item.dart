import 'package:flutter/material.dart';
import 'package:hadith/constants/app_constants.dart';
import 'package:hadith/features/home/widget/home_card.dart';

class HomeSubItem extends StatelessWidget {
  final void Function() onTap;
  final String title;
  final IconData iconData;

  const HomeSubItem(
      {Key? key,
      required this.onTap,
      required this.title,
      required this.iconData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(19);
    final textStyle = Theme.of(context).textTheme.headline6;
    final color =
        kIsTextBlackWithLightPrimary ? Colors.black : textStyle?.color;

    return HomeCard(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: textStyle?.copyWith(fontWeight: FontWeight.w400, color: color),
      ),
      leading: Icon(
        iconData,
        size: 30,
        color: color,
      ),
      onTap: onTap,
      cardColor: Theme.of(context).primaryColorLight,
      rectangleBorder: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(width: 0.5, color: color ?? Colors.black)),
    );
  }
}
