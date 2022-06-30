import 'package:flutter/material.dart';
import 'package:hadith/features/home/widget/home_sub_item.dart';

class HomeBookItem extends StatelessWidget {
  final HomeSubItem item1;
  final HomeSubItem item2;
  final HomeSubItem item3;
  final HomeSubItem? item4;
  final String title;
  const HomeBookItem({Key? key,required this.item1,required this.item2,
    required this.item3,this.item4,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(19))),
      child: Column(
        children: [
          const SizedBox(height: 10,),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(
                flex: 7,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: ListTile(
                    horizontalTitleGap: 0,
                    minVerticalPadding: 20,
                    minLeadingWidth: 0,
                    contentPadding: const EdgeInsets.only(left: 30,right: 30),
                    tileColor: Theme.of(context).cardTheme.color,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19),
                    side: BorderSide(width: 0.7,color: Theme.of(context).textTheme.headline5?.color??Colors.black)),
                    leading: Icon(Icons.view_quilt,size: 40,color: Theme.of(context).iconTheme.color,),
                    title: Text(title,textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(flex: 5,child: item1),
              const Expanded(child: SizedBox()),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(flex: 5,child: item2),
              const Expanded(child: SizedBox()),
            ],
          ),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(flex: 5,child: item3),
              const Expanded(child: SizedBox()),
            ],
          ),
          item4!=null?Row(
            children: [
              const Expanded(child: SizedBox()),
              Expanded(flex: 5,child: item4!),
              const Expanded(child: SizedBox()),
            ],
          ):const SizedBox(height: 0,),
          const SizedBox(height: 30,)
        ],
      ),
    );
  }
}
