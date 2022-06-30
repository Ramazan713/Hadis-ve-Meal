

import 'package:flutter/material.dart';
import 'package:hadith/widgets/custom_button_positive.dart';

void showInfoBottomDia(BuildContext context,{required String title,required String content}){
  showModalBottomSheet(context: context,isScrollControlled: true, builder: (BuildContext context){
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 13,),
          Text(title,style: Theme.of(context).textTheme.headline6,),
          const SizedBox(height: 5,),
          Text(content,style: Theme.of(context).textTheme.bodyText1,),
          const SizedBox(height: 27,),
          CustomButtonPositive(onTap: (){
            Navigator.pop(context);
          },label: "Tamam",),
        ],
      ),
    );
  });
}