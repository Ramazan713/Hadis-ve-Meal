

import 'package:flutter/material.dart';
import 'package:hadith/utils/theme_util.dart';


import '../constants/enums/search_criteria_enum.dart';

class TextUtils{
  static List<TextSpan>getSelectedText(String fullText,String? searchKey,
  {bool caseSensitive=false,TextStyle? textStyle,required BuildContext context,
    bool inheritTextStyle=false,required SearchCriteriaEnum searchCriteriaEnum}){
    List<TextSpan>spans=[];
    TextStyle searchStyle=TextStyle(
      backgroundColor: ThemeUtil.getThemeModel(context).selectedTextColor()
    );

    if(searchKey!=null){
      if(inheritTextStyle&&textStyle!=null){
        searchStyle=searchStyle.merge(textStyle);
      }
      final RegExp reg;
      switch(searchCriteriaEnum){
        case SearchCriteriaEnum.oneExpression:
          reg=RegExp(searchKey,caseSensitive: caseSensitive);
          break;
        case SearchCriteriaEnum.multipleKeys:
          reg=RegExp(searchKey.split(' ').map((e) => "$e|").join(''),caseSensitive: caseSensitive);
          break;
      }

      var firstIndex=0;
      for(var matcher in reg.allMatches(fullText)){
        if(firstIndex<matcher.start){
          spans.add(TextSpan(text: fullText.substring(firstIndex,matcher.start),style: textStyle));
        }
        final text=fullText.substring(matcher.start,matcher.end);
        spans.add(TextSpan(text: text,style: searchStyle));
        firstIndex=matcher.end;
      }

      if(firstIndex<fullText.length){
        spans.add(TextSpan(text: fullText.substring(firstIndex,fullText.length),style: textStyle));
      }
    }else{
      spans.add(TextSpan(text: fullText,style: textStyle));
    }
    return spans;
  }
}