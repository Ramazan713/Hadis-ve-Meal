
import 'package:flutter/material.dart';
import 'package:hadith/widgets/custom_button_negative.dart';
import 'package:hadith/widgets/custom_button_positive.dart';

void showGetNumberBottomDia(BuildContext context,Function(int selectedIndex) listener,
    {required int currentIndex,required int limitIndex}){
  final _formKey = GlobalKey<FormState>();

  showModalBottomSheet(context: context,
      isScrollControlled: true,
      builder: (context){
    var controller=TextEditingController(text: (currentIndex+1).toString());
    controller.selection=TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    return SingleChildScrollView(
      padding: MediaQuery.of(context).viewInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: const EdgeInsets.symmetric(vertical: 19),
              child: Text("1 ile ${limitIndex+1} arasında bir sayı giriniz",
                textAlign: TextAlign.center,style: Theme.of(context).textTheme.subtitle1,)),
          Form(
            key: _formKey,
            child: TextFormField(
              autofocus: true,
              controller: controller,
              keyboardType: TextInputType.number,
              validator: (text){
                if(text==null||text.trim()==""){
                  return "yazı alanı boş geçilemez";
                }
                var reg=RegExp(r"^[0-9]+$");
                if(!reg.hasMatch(text)){
                  return "yalnızca sayı giriniz";
                }
                int value=int.parse(text);
                if(value<1||value>limitIndex+1){
                  return "lütfen sayıyı değer aralığında giriniz";
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 19,),
          Row(
            children: [
              Expanded(
                child: CustomButtonNegative(onTap: (){
                  Navigator.pop(context);
                }),
              ),
              Expanded(
                child: CustomButtonPositive(onTap: (){
                  if(_formKey.currentState!.validate()){
                    var text=controller.text;
                    listener.call(int.parse(text)-1);
                    Navigator.pop(context);
                  }
                }),
              )
            ],
          )
        ],
      ),
    );
  });
}