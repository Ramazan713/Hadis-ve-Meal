
import 'package:flutter/material.dart';
import 'package:hadith/db/entities/list_entity.dart';


class SelectListItem extends StatelessWidget{
  late final bool _isSelected;
  final bool? isParentList;
  final ListEntity item;
  final void Function(bool isSelected) listener;
  SelectListItem({Key? key,required bool isSelected,this.isParentList,
    required this.item,required this.listener}) : super(key: key){
    _isSelected=isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isParentList==true?Theme.of(context).selectedRowColor:Theme.of(context).cardColor,
      child: ListTile(
        leading: Checkbox(
          value: _isSelected,
          onChanged: (isChecked) {
            listener.call(!_isSelected);
          },
        ),
        title: Text(item.name),
        onTap: () {
          listener.call(!_isSelected);
        },
      ),
    );
  }
}
