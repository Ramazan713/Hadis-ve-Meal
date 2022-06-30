import 'package:flutter/material.dart';
import 'package:hadith/themes/model/i_theme_model.dart';
import 'package:hadith/utils/theme_util.dart';

class PremiumSubscriptionItem extends StatelessWidget {
  final String title;
  final String price;
  final String? trialContent;
  final void Function()onClick;
  const PremiumSubscriptionItem({Key? key,required this.title,required this.price,
    this.trialContent,required this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final IThemeModel _themeModel=ThemeUtil.getThemeModel(context);
    final body1TextStyle=Theme.of(context).textTheme.bodyText1;

    return ListTile(
      tileColor: _themeModel.getCyanShadeColor(),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19),
          side: BorderSide(
            color: body1TextStyle?.color??Colors.black
          )
      ),
      onTap: onClick,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title,textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,),
          const SizedBox(height: 7,),
          Text(price,textAlign: TextAlign.center,
            style: body1TextStyle,),
          const SizedBox(height: 7,),
          trialContent==null?const SizedBox():
            Text(trialContent??"",textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,)
        ],
      ),
    );
  }
}
