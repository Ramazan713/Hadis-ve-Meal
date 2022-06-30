

import 'package:flutter/material.dart';

import '../widgets/menu_item_tile.dart';

void showSelectMenuItemDia(BuildContext context,{required List<IconTextItem> items,
  String? title}){

  List<Widget>getChildren(){
    final widgets=<Widget>[];
    if(title!=null){
      widgets.add(const SizedBox(height: 13,));
      widgets.add(Text(title,style: Theme.of(context).textTheme.headline6,
        textAlign: TextAlign.center,));
    }
    widgets.add(const SizedBox(height: 5,));
    widgets.addAll(items);
    return widgets;
  }

  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context){
        return SingleChildScrollView(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getChildren(),
            ),
          ),
        );
      }
  );
}