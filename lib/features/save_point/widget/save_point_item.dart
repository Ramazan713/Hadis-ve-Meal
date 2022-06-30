import 'package:flutter/material.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/constants/extensions.dart';
import 'package:hadith/constants/save_point_constant.dart';
import 'package:hadith/db/entities/savepoint.dart';

class SavePointItem extends StatelessWidget {
  final SavePoint item;
  final void Function()?editTitleListener;
  final void Function()?removeItemListener;
  final bool isSelected;
  final bool showOriginText;

  const SavePointItem({Key? key,required this.item,
    required this.isSelected,this.editTitleListener,this.removeItemListener,
    required this.showOriginText})
      : super(key: key);


  List<Widget>getBottomChildren(TextStyle? bodyStyle){
    List<Widget>children=[];

    if(kSavePointScopeOrigins.contains(item.savePointType)){
      children.add(Flexible(flex: 3,child: Text(item.parentName,style: bodyStyle,)));
    }else if(showOriginText){
      children.add(Flexible(flex: 3,child: Text(item.savePointType.shortName,style: bodyStyle,)));
    }

    children.add(Flexible(flex: 3, child: Text("pos: ${item.itemIndexPos} ",style: bodyStyle,)));
    children.add(Flexible(flex: 5, child: Text(DateTimeFormats.formatDate1(item.modifiedDate),style: bodyStyle,)));
    return children;
  }

  @override
  Widget build(BuildContext context) {

    final TextStyle? bodyStyle=Theme.of(context).textTheme.bodyText2;

    return Card(
      color: isSelected?Theme.of(context).selectedRowColor:Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 3, horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
                padding: const EdgeInsets.all(7),
                child: Column(
                  children: [
                    const Icon(
                      Icons.save,
                      size: 30,
                    ),
                    item.isAuto?Text("auto",style: bodyStyle,):const SizedBox()
                  ],
                )),
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: Row(
                      children: [
                        IconButton(onPressed: editTitleListener, icon: const Icon(Icons.edit)),
                        Flexible(child: Text("${item.title} ",style: bodyStyle,))
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children:getBottomChildren(bodyStyle),
                  )
                ],
              ),
            ),
            IconButton(
                onPressed: removeItemListener,
                icon: Icon(
                  Icons.delete,
                  color: Colors.red.shade300,
                )),
          ],
        ),
      ),
    );
  }
}
