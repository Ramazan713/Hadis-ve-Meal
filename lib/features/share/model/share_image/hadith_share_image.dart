import 'package:flutter/material.dart';
import 'package:hadith/features/hadith/model/hadith_topics_model.dart';
import 'package:hadith/features/share/model/share_image/i_share_image.dart';


class HadithShareImage extends IShareImage<HadithTopicsModel>{

  @override
  Widget getPreviewWidgetKey(BuildContext context, item, GlobalKey<State<StatefulWidget>> globalKey) {
    final hadith=item.item;
    final  textStyle=Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: fontSize,
        fontWeight: FontWeight.w400,inherit: true);
    return RepaintBoundary(
        key: globalKey,
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.only(left: 7, right: 7, top: 13, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Text(hadith.content,
                    textAlign: TextAlign.center,
                    style: textStyle,
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Text("- ${hadith.source}",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: fontSize-4)),
                ],
              ),
            ),
          ),
        )
    );
  }

  @override
  String getImageName(HadithTopicsModel item) {
    return "${item.item.id}-Hadis.png";
  }

}