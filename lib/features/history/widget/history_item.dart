import 'package:flutter/material.dart';
import 'package:hadith/db/entities/history_entity.dart';

class HistoryItem extends StatelessWidget {
  final HistoryEntity historyEntity;
  final void Function()? onClick;
  final void Function()? onRemoveClick;

  const HistoryItem({Key? key,required this.historyEntity,this.onClick,
    this.onRemoveClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 13,vertical: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onClick,
        child: Row(
          children: [
            const SizedBox(width: 19,),
            Expanded(child: Text(historyEntity.name,style: Theme.of(context).textTheme.bodyText1,)),
            IconButton(onPressed: onRemoveClick, icon: const Icon(Icons.clear)),
            const SizedBox(width: 7,)
          ],
        ),
      )
    );
  }
}
