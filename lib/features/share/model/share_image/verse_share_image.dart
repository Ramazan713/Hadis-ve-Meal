import 'package:flutter/material.dart';
import 'package:hadith/constants/enums/verse_arabic_ui_enum.dart';
import 'package:hadith/constants/preference_constants.dart';
import 'package:hadith/features/share/model/share_image/i_share_image.dart';
import 'package:hadith/features/verse/model/verse_model.dart';
import 'package:hadith/features/verse/verse_helper_funcs.dart';
import 'package:hadith/utils/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareVerseImage extends IShareImage<VerseModel>{
  final SharedPreferences sharedPreferences=LocalStorage.sharedPreferences;



  @override
  Widget getPreviewWidgetKey(BuildContext context,VerseModel item, GlobalKey<State<StatefulWidget>> globalKey) {
    final verse=item.item;

    final  textStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
        fontSize: fontSize,fontWeight: verse.isProstrationVerse ? FontWeight.w700 : FontWeight.normal, inherit: true
    );
    ArabicVerseUIEnum arabicVerseUIEnum=ArabicVerseUIEnum.values[sharedPreferences.getInt(PrefConstants.arabicVerseAppearanceEnum.key)
        ??PrefConstants.arabicVerseAppearanceEnum.defaultValue];

    return RepaintBoundary(
        key: globalKey,
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
            child: InkWell(
              borderRadius: BorderRadius.circular(19),
              child: Ink(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 3,),
                      Text(
                        "${verse.surahId}/${verse.surahName}",
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: fontSize - 5),
                      ),
                      ... getVerseItemContent([TextSpan(text: verse.content)],
                          item, fontSize, textStyle, arabicVerseUIEnum)
                    ],
                  ),
                ),
              ),
            ),
          )
        )
    );
  }

  @override
  String getImageName(VerseModel item) {
   return "${item.item.surahName}-${item.item.verseNumber}-Ayet.png";
  }

}