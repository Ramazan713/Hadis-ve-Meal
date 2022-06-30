import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hadith/db/entities/helper/item_count_model.dart';

class TopicTileItem extends StatelessWidget {
  final ItemCountModel itemCountModel;
  final void Function() onTap;
  final void Function()? onLongPress;
  final String itemLabel;
  final bool isSavePoint;

  const TopicTileItem(
      {Key? key,
      required this.itemLabel,
      this.onLongPress,
      required this.itemCountModel,
      required this.isSavePoint,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bodyText2Style = Theme.of(context).textTheme.bodyText2;

    return Card(
        color: Theme.of(context).colorScheme.secondary,
        child: ListTile(
          title: Text(
            itemCountModel.name,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.bookOpenReader,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(
                height: 7,
              ),
              itemCountModel.rowNumber == null
                  ? const SizedBox()
                  : Text(
                      "${itemCountModel.rowNumber}",
                      style: bodyText2Style?.copyWith(
                          fontSize: (bodyText2Style.fontSize ?? 3) - 3),
                    )
            ],
          ),
          subtitle: Text(
            "${itemCountModel.itemCount} $itemLabel",
            style: bodyText2Style,
          ),
          onTap: onTap,
          onLongPress: onLongPress,
          trailing: isSavePoint
              ? Icon(
                  Icons.beenhere,
                  color: Theme.of(context).errorColor,
                )
              : null,
        ));
  }
}
