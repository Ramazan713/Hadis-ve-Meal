import 'package:flutter/material.dart';
import 'package:hadith/constants/app_constants.dart';
import 'package:hadith/constants/enums/search_criteria_enum.dart';
import 'package:hadith/utils/text_utils.dart';
import 'package:hadith/features/hadith/model/hadith_topics_model.dart';

class HadithScrollableItem extends StatefulWidget {
  final HadithTopicsModel hadithTopic;
  final double fontSize;
  final void Function()? shareIconClick;
  final void Function(bool isFavori, void Function(void Function()))?
      favoriteIconClick;
  final void Function(void Function(void Function()))? listIconClick;
  final String? searchKey;
  final SearchCriteriaEnum searchCriteriaEnum;

  HadithScrollableItem(
      {Key? key,
      required this.hadithTopic,
      required this.fontSize,
      this.shareIconClick,
      this.favoriteIconClick,
      this.searchKey,
      required this.searchCriteriaEnum,
      this.listIconClick})
      : super(key: key) {
    iconSize = fontSize + 7;
  }

  late final double iconSize;

  @override
  State<HadithScrollableItem> createState() => _HadithScrollableItemState();
}

class _HadithScrollableItemState extends State<HadithScrollableItem> {
  late TextStyle? textStyle;

  var showContinueClick = false;

  @override
  Widget build(BuildContext context) {
    final hadith = widget.hadithTopic.item;
    final String topicText =
        widget.hadithTopic.topics.map((e) => e.name).join("; ");

    final isContentLarge = hadith.contentSize > kMaxContentSize;

    final content = !showContinueClick && isContentLarge
        ? hadith.content.substring(0, kMaxContentSize)
        : hadith.content;

    textStyle = Theme.of(context).textTheme.bodyText1?.copyWith(
        fontSize: widget.fontSize, fontWeight: FontWeight.w400, inherit: true);

    final contentTextBody = TextUtils.getSelectedText(content, widget.searchKey,
        searchCriteriaEnum: widget.searchCriteriaEnum,
        context: context,
        textStyle: textStyle,
        inheritTextStyle: true);

    final showContinueWidget = TextSpan(children: [
      WidgetSpan(
          child: InkWell(
        child: Text(
          "  ... devamını göster",
          style: textStyle?.copyWith(
              fontWeight: FontWeight.w500, fontSize: widget.fontSize - 2),
        ),
        onTap: () {
          setState(() {
            showContinueClick = true;
          });
        },
      )),
    ]);

    if (!showContinueClick && isContentLarge) {
      contentTextBody.add(showContinueWidget);
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.only(left: 7, right: 7, top: 13, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${hadith.rowNumber}",
                  textAlign: TextAlign.start,
                  style: textStyle?.copyWith(fontSize: widget.fontSize - 2),
                ),
                const SizedBox(width: 7,),
                Expanded(
                  child: Text("- $topicText",
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          ?.copyWith(fontSize: widget.fontSize - 4)),
                ),
                const SizedBox(width: 33,)
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            RichText(
              text: TextSpan(
                children: contentTextBody,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 13,
            ),
            Text("- ${hadith.source}",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText1
                    ?.copyWith(fontSize: widget.fontSize - 4)),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(),
                IconButton(
                  onPressed: widget.shareIconClick ?? () {},
                  icon: const Icon(Icons.share),
                  iconSize: widget.iconSize,
                ),
                IconButton(
                  onPressed: () {
                    widget.favoriteIconClick
                        ?.call(!widget.hadithTopic.isFavorite, setState);
                  },
                  icon: Icon(
                    Icons.favorite,
                    color: widget.hadithTopic.isFavorite ? Colors.red : null,
                  ),
                  iconSize: widget.iconSize,
                ),
                IconButton(
                  onPressed: () {
                    widget.listIconClick?.call(setState);
                  },
                  icon: widget.hadithTopic.isAddListNotEmpty
                      ? const Icon(Icons.library_add_check)
                      : const Icon(Icons.library_add),
                  iconSize: widget.iconSize,
                ),
                const SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
