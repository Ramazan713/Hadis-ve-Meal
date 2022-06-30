import 'package:flutter/material.dart';
import 'package:hadith/widgets/custom_button_negative.dart';
import 'package:hadith/widgets/custom_button_positive.dart';

void showPreviewSharedImageDia(BuildContext context,{required Widget previewWidget,required Function()onTap}){
  showDialog(context: context, builder: (context){
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 5),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Paylaşılacak Olan Resim",style: Theme.of(context).textTheme.bodyText1,),
            const SizedBox(height: 13,),
            previewWidget
          ],
        ),
      ),
      actions: [
        CustomButtonNegative(onTap: (){
          Navigator.pop(context);
        },label: "Iptal",),
        CustomButtonPositive(onTap:onTap,label: "Paylaş",),

      ],
    );
  });
}