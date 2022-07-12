import 'package:flutter/material.dart';
import 'package:hadith/constants/enums/search_criteria_enum.dart';
import 'package:hadith/constants/enums/verse_arabic_ui_enum.dart';
import 'package:hadith/features/verse/verse_helper_funcs.dart';
import 'package:hadith/utils/text_utils.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/features/verse/model/verse_model.dart';

class VerseItem extends StatelessWidget {
  final Function() onLongPress;
  final VerseModel verseModel;
  final double fontSize;
  final double _borderRadius = 13;
  final bool showRowNumber;
  final String? searchKey;
  final SearchCriteriaEnum searchCriteriaEnum;
  final ArabicVerseUIEnum arabicVerseUIEnum;

  late final TextStyle? contentTextStyle;

  late final Verse verse;
  VerseItem(
      {Key? key,
      required this.fontSize,
        required this.arabicVerseUIEnum,
      required this.verseModel,
      this.showRowNumber = false,
      this.searchKey,
      required this.searchCriteriaEnum,
      required this.onLongPress})
      : super(key: key) {
    verse = verseModel.item;
  }

  Widget getRowNumberWidget() {
    if (showRowNumber && verse.rowNumber != null) {
      return Text("${verse.rowNumber}",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: fontSize - 5));
    }
    return const SizedBox();
  }








  @override
  Widget build(BuildContext context) {
    contentTextStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
        fontSize: fontSize,
        fontWeight:
            verse.isProstrationVerse ? FontWeight.w700 : FontWeight.normal,
        inherit: true);



    final content = TextUtils.getSelectedText(verse.content, searchKey,
        textStyle: contentTextStyle,
        context: context,
        inheritTextStyle: true,
        searchCriteriaEnum: searchCriteriaEnum);

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius)),
      child: InkWell(
        borderRadius: BorderRadius.circular(_borderRadius),
        onLongPress: onLongPress,
        child: Ink(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${verse.surahId}/${verse.surahName}",
                        style: Theme.of(context).textTheme.bodyText1
                            ?.copyWith(fontSize: fontSize - 5),
                      ),
                    ),
                    Expanded(child: getRowNumberWidget()),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          getVerseItemInfoWidget(context,verse,fontSize),
                          Text("${verse.pageNo}",
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodyText1
                                  ?.copyWith(fontSize: fontSize - 5))
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 7, bottom: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: getVerseItemContent(content,verseModel,fontSize,contentTextStyle,arabicVerseUIEnum),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
