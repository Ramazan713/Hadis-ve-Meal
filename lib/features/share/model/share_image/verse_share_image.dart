import 'package:flutter/material.dart';
import 'package:hadith/constants/verse_constant.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/features/share/model/share_image/i_share_image.dart';

class ShareVerseImage extends IShareImage<Verse>{

  Widget _getMentionWidget(Verse verse) {
    var verseNum = int.parse(verse.verseNumber.split(",")[0]);
    if (verseNum==1&&!VerseConstant.mentionExclusiveIds.contains(verse.surahId)) {
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 19),
          child: Text(
            VerseConstant.mentionText,
            textAlign: TextAlign.start,
          ));
    }
    return const SizedBox(
      height: 0,
    );
  }


  @override
  Widget getPreviewWidgetKey(BuildContext context,Verse item, GlobalKey<State<StatefulWidget>> globalKey) {

    final  textStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
        fontSize: fontSize,fontWeight: item.isProstrationVerse ? FontWeight.w700 : FontWeight.normal, inherit: true
    );


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
                        "${item.surahId}/${item.surahName}",
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: fontSize - 5),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 7, bottom: 13),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _getMentionWidget(item),
                              Text("${item.verseNumber} - ${item.content}",style: textStyle,)
                            ],
                          )),
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
  String getImageName(Verse item) {
   return "${item.surahName}-${item.verseNumber}-Ayet.png";
  }

}