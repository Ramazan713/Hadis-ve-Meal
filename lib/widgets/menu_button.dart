import 'package:flutter/material.dart';
import 'package:hadith/models/menu_model.dart';

class MenuButton<E> extends StatelessWidget {

  final List<MenuModel<E>> items;
  final Function(E enumType) selectedFunc;

  const MenuButton({Key? key, required this.items,required this.selectedFunc}) : super(key: key);

  PopupMenuItem<E> getMenuItem(MenuModel<E> menuItem,TextStyle? textStyle) {
    return PopupMenuItem(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: 20,
        value: menuItem.value,
        child: Row(
          children: [
            Icon(
              menuItem.iconData,
              color: textStyle?.color,
            ),
            const SizedBox(
              width: 7,
            ),
            Text(menuItem.label,style: textStyle)
          ],
        ));
  }

  List<PopupMenuItem<E>> getPopupMenuItemsList(TextStyle? textStyle){
    List<PopupMenuItem<E>>popItems=[];
    for (var element in items) {
      popItems.add(getMenuItem(element,textStyle));
    }
    return popItems;
  }

  @override
  Widget build(BuildContext context) {

    final textStyle=Theme.of(context).textTheme.bodyText2?.copyWith(
        fontSize: (Theme.of(context).textTheme.bodyText2?.fontSize??15)+1
    );

    return PopupMenuButton<E>(
      itemBuilder: (context) => getPopupMenuItemsList(textStyle),
      onSelected:selectedFunc,
    );
  }
}
