import 'package:flutter/material.dart';

void showShareAlertDialog(BuildContext context,{required List<Widget>listItems,
  String title="Paylaşma Seçenekleri"}){
  showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Text(title,style: Theme.of(context).textTheme.headline6,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: listItems,
      ),

    );
  });
}