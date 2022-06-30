import 'package:flutter/material.dart';
import 'package:hadith/widgets/menu_item_tile.dart';

void showBottomMenu(BuildContext context, {required List<IconTextItem> items}) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [...items,
                const SizedBox(height: 30,)
              ],
            ),
          ),
        );
      });
}
