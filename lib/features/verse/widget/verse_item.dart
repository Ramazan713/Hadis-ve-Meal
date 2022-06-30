import 'package:flutter/material.dart';
import 'package:hadith/constants/enums/search_criteria_enum.dart';
import 'package:hadith/utils/text_utils.dart';
import 'package:hadith/constants/verse_constant.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/dialogs/show_info_bottom_dia.dart';
import 'package:hadith/features/verse/model/verse_model.dart';

class VerseItem extends StatelessWidget {
  final Function() onLongPress;
  final VerseModel verseModel;
  final double fontSize;
  final double _borderRadius = 13;
  final bool showRowNumber;
  final String? searchKey;
  final SearchCriteriaEnum searchCriteriaEnum;

  late final TextStyle? contentTextStyle;

  late final Verse verse;
  VerseItem(
      {Key? key,
      required this.fontSize,
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

  Widget getInfoWidget(BuildContext context) {
    return verse.isProstrationVerse
        ? IconButton(
            onPressed: () {
              showInfoBottomDia(context,
                  title: "Uyarı", content: "Koyu renkli alan secde ayetidir");
            },
            icon: Icon(Icons.info, size: fontSize + 5))
        : const SizedBox(height: 0,);
  }

  Widget getMentionWidget() {
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
                          getInfoWidget(context),
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
                      children: [
                        getMentionWidget(),
                        RichText(
                            text: TextSpan(
                                text: "${verse.verseNumber} - ",
                                children: content,
                                style: contentTextStyle))
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
