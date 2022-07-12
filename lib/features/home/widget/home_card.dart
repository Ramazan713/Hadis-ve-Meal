

import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final Widget leading;
  final RoundedRectangleBorder? rectangleBorder;
  final Widget title;
  final void Function()? onTap;
  final Color? cardColor;
  const HomeCard({Key? key,required this.title,this.rectangleBorder,
    this.onTap,required this.leading,this.cardColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      color: cardColor,
      shape: rectangleBorder,
      margin: const EdgeInsets.symmetric(vertical: 7),
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(borderRadius: rectangleBorder?.borderRadius??BorderRadius.circular(19)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 19),
          child: Row(
            children: [
              leading,
              const SizedBox(
                width: 7,
              ),
              Expanded(child:title),
              const SizedBox(
                width: 13,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
