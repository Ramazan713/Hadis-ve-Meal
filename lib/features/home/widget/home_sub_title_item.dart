
import 'package:flutter/material.dart';

class HomeSubTitleItem extends StatelessWidget {
   const HomeSubTitleItem({Key? key,required this.isSelected,required this.onTap,required this.title}) : super(key: key);
  final bool isSelected;
  final void Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    final textStyle=Theme.of(context).textTheme.subtitle1;
    final textFontSize=textStyle?.fontSize??19;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: InkWell(
        onTap: onTap,
        borderRadius:  BorderRadius.circular(7),
        child: Padding(
          padding: const EdgeInsets.only(left: 27,right: 27,top: 7,bottom: 4),
          child: Text(title,style: textStyle?.copyWith(
              fontSize: isSelected?textFontSize+2:textFontSize,
              shadows: [
                Shadow(
                  color: textStyle.color??Colors.black,
                    offset: const Offset(0, -3))
              ],
              fontWeight: isSelected?FontWeight.w500:FontWeight.normal,
              color: Colors.transparent,
              decorationColor: textStyle.color,
              decoration: isSelected?TextDecoration.underline:TextDecoration.none,
              decorationThickness: 1),),
        ),
      )
    );
  }
}
