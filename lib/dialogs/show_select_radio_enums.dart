import 'package:flutter/material.dart';
import 'package:hadith/widgets/custom_button_positive.dart';
import 'package:hadith/models/item_label_model.dart';

void showSelectRadioEnums<T extends Enum>(BuildContext context,
    {required ItemLabelModel<T> currentValue,
    required List<ItemLabelModel<T>> radioItems,
    required void Function(ItemLabelModel<T> lastSelected) closeListener}) {

  List<Widget> getTileItems(BuildContext context, void Function(void Function()) alertSetState) {

    List<Widget> tileItems = [];

    for (var radioItem in radioItems) {
      tileItems.add(RadioListTile<ItemLabelModel<T>>(
        title: Text(
          radioItem.label,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        value: radioItem,
        onChanged: (value) {
          if (value != null) {
            alertSetState(() {
              currentValue = value;
            });
          }
        },
        groupValue: currentValue,
      ));
    }
    return tileItems;
  }

  showDialog<ItemLabelModel>(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 19),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 5),
            child: Column(
              children: [
                StatefulBuilder(
                  builder: (context, alertSetState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: getTileItems(context, alertSetState),
                    );
                  },
                ),
                const SizedBox(
                  height: 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButtonPositive(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      label: "Onayla",
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) {
    closeListener.call(currentValue);
  });
}
