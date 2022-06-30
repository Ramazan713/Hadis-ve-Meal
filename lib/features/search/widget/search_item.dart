import 'package:flutter/material.dart';
import 'package:hadith/constants/app_constants.dart';

class SearchItem extends StatelessWidget {
  final String title;
  final int resultCount;
  final int position;
  final void Function()?onForwardClick;
  const SearchItem({Key? key,required this.title,
  required this.resultCount,required this.position,required this.onForwardClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color=kIsTextBlackWithLightPrimary?
      Colors.black:Theme.of(context).textTheme.bodyText2?.color;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 13,vertical: 7),
      color: Theme.of(context).primaryColorLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onForwardClick,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 19,horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 7,),
              Text("$position",style:
              Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w500,color: color),),
              const SizedBox(width: 29,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.w700,color: color),),
                    const SizedBox(height: 7,),
                    Text("$resultCount sonuc bulundu",style: Theme.of(context).textTheme.bodyText2?.copyWith(color: color),),
                  ],
                ),
              ),
              IconButton(onPressed: onForwardClick, icon: Icon(Icons.arrow_forward,size: 30,color: color,))
            ],
          ),
        ),
      ),
    );
  }
}
