import 'package:flutter/material.dart';
import 'package:hadith/constants/enums/verse_arabic_ui_enum.dart';
import 'package:hadith/constants/verse_constant.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/db/entities/verse_arabic.dart';
import 'package:hadith/dialogs/show_info_bottom_dia.dart';
import 'package:hadith/features/verse/model/verse_model.dart';


List<Widget> getVerseItemContent(List<TextSpan> content,VerseModel verseModel,double fontSize
    ,TextStyle? contentTextStyle,ArabicVerseUIEnum arabicVerseUIEnum){
  final contents=<Widget>[
    getVerseItemMentionWidget(verseModel.item,fontSize,contentTextStyle),
    const SizedBox(height: 7,),
  ];
  final showTurkishVerseNum = arabicVerseUIEnum == ArabicVerseUIEnum.onlyArabic;

  if([ArabicVerseUIEnum.onlyArabic,ArabicVerseUIEnum.both].contains(arabicVerseUIEnum)){
    contents.add(getArabicVerseWidget(verseModel,fontSize,contentTextStyle
        ,showTurkishVerseNum));
    contents.add(const SizedBox(height: 13,));
  }
  if([ArabicVerseUIEnum.onlyMeal,ArabicVerseUIEnum.both].contains(arabicVerseUIEnum)){
    contents.add( RichText(
        text: TextSpan(
            text: "${verseModel.item.verseNumber} - ",
            children: content,
            style: contentTextStyle)));
  }
  return contents;
}


Widget getVerseItemInfoWidget(BuildContext context,Verse verse,double fontSize) {
  return verse.isProstrationVerse
      ? IconButton(
      onPressed: () {
        showInfoBottomDia(context,
            title: "Uyarı", content: "Koyu renkli alan secde ayetidir");
      },
      icon: Icon(Icons.info, size: fontSize + 5))
      : const SizedBox(height: 0,);
}

Widget getVerseItemMentionWidget(Verse verse,double fontSize,TextStyle? contentTextStyle) {
  var verseNum = int.parse(verse.verseNumber.split(",")[0]);
  if (verseNum == 1 &&
      !VerseConstant.mentionExclusiveIds.contains(verse.surahId)) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 19),
        child: Text(
          VerseConstant.mentionText,
          textAlign: TextAlign.start,
          style: contentTextStyle?.copyWith(
              fontSize:fontSize-3
          ),
        ));
  }
  return const SizedBox(
    height: 0,
  );
}

Widget getArabicVerseWidget(VerseModel verseModel,double fontSize,TextStyle? contentTextStyle,
    bool showTurkishVerseNum){
  final children=<InlineSpan>[];
  final verseStopImg=Image.asset("assets/images/verse_stop.png",width: fontSize+7,height: fontSize+3);

  if(showTurkishVerseNum){
    children.add(TextSpan(text: "${verseModel.item.verseNumber} - ",style: contentTextStyle?.copyWith(
        fontSize: fontSize+2
    )));
  }
  for(var arabicVerse in verseModel.arabicVerses){
    children.add(TextSpan(
      style: TextStyle(fontSize: fontSize+5),
      children: [
        TextSpan(text: arabicVerse.verse,style: contentTextStyle?.copyWith(
            fontFamily: "ScheherazadeNew",
            fontSize: fontSize+11,
            height: 2.0
        )),
        WidgetSpan(child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(width: fontSize+13,),
            verseStopImg,
            Text(arabicVerse.verseNumber,)
          ],
        )),
      ],
    ));
  }
  return RichText(text: TextSpan(children: children),textDirection: TextDirection.rtl,);
}