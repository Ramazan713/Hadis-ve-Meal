import 'package:flutter/material.dart';
import 'package:hadith/constants/enums/search_criteria_enum.dart';
import 'package:hadith/constants/enums/verse_arabic_ui_enum.dart';
import 'package:hadith/features/verse/verse_helper_funcs.dart';
import 'package:hadith/themes/model/i_theme_model.dart';
import 'package:hadith/utils/text_utils.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/features/verse/model/verse_model.dart';
import 'package:hadith/utils/theme_util.dart';

class VerseItem extends StatelessWidget {
  final Function() onLongPress;
  final VerseModel verseModel;
  final double fontSize;
  final int rowNumber;
  final double _borderRadius = 13;
  final String? searchKey;
  final bool showListVerseIcons;
  final SearchCriteriaEnum searchCriteriaEnum;
  final ArabicVerseUIEnum arabicVerseUIEnum;

  late final TextStyle? contentTextStyle;

  late final Verse verse;
  VerseItem(
      {Key? key,
      required this.fontSize,
      required this.arabicVerseUIEnum,
      required this.verseModel,
      required this.rowNumber,
      required this.showListVerseIcons,
      this.searchKey,
      required this.searchCriteriaEnum,
      required this.onLongPress})
      : super(key: key) {
    verse = verseModel.item;
  }

  Widget getRowNumberWidget() {
    return Text("$rowNumber",
        textAlign: TextAlign.center, style: TextStyle(fontSize: fontSize - 5));
  }

  List<Widget> getListIconsWidgetList(
      BuildContext context, double fontSize, TextStyle? style) {
    final items = <Widget>[];
    final IThemeModel themeModel=ThemeUtil.getThemeModel(context);

    final double iconSize = fontSize - 3;
    const opacity = 0.7;

    if (verseModel.isAddListNotEmpty) {
      items.add(Icon(
        Icons.library_add_check,
        size: iconSize,
        color: style?.color?.withOpacity(opacity),
      ));
      items.add(const SizedBox(
        width: 5,
      ));
    }

    if (verseModel.isFavorite) {
      items.add(Icon(
        Icons.favorite,
        color: Theme.of(context).errorColor.withOpacity(opacity),
        size: iconSize,
      ));
      items.add(const SizedBox(
        width: 5,
      ));
    }

    if (verseModel.isArchiveAddedToList) {
      items.add(Icon(
        Icons.library_add_check,
        size: iconSize,
        color:themeModel.getBlueShadeColor().withOpacity(opacity),
      ));

    }


    return items;
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
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            ?.copyWith(fontSize: fontSize - 5),
                      ),
                    ),
                    Expanded(child: getRowNumberWidget()),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          getVerseItemInfoWidget(context, verse, fontSize),
                          Text("${verse.pageNo}",
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
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
                      children: getVerseItemContent(content, verseModel,
                          fontSize, contentTextStyle, arabicVerseUIEnum),
                    )),
                showListVerseIcons? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: getListIconsWidgetList(context, fontSize, contentTextStyle),
                ):const SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
