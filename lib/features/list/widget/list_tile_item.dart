import 'package:flutter/material.dart';
import 'package:hadith/constants/enums/sourcetype_enum.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';

class ListTileItem extends StatelessWidget {
  final IListView listModel;
  final void Function() menuListener;
  late final Icon icon;
  final void Function() onTap;
  final SourceTypeEnum sourceTypeEnum;
  ListTileItem(
      {Key? key,
      required this.sourceTypeEnum,
      required this.listModel,
      required Icon defaultIcon,
      required this.onTap,
      required this.menuListener})
      : super(key: key) {

    icon = listModel.isRemovable ? defaultIcon :
        const Icon(Icons.favorite, size: 30, color: Colors.red,);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      child: ListTile(
        title: Text(
          listModel.name,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        leading: icon,
        subtitle: Text(
          "${listModel.itemCounts} ${sourceTypeEnum.shortName}",
          style: Theme.of(context).textTheme.bodyText2,
        ),
        trailing: IconButton(
          onPressed: () {
            menuListener.call();
          },
          icon: Icon(
            Icons.more_vert,
            size: 30,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
