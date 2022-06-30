import 'package:flutter/material.dart';

import '../../../themes/model/i_theme_model.dart';
import '../../../utils/theme_util.dart';

class PremiumFeatureItem extends StatelessWidget {
  final String featureName;
  const PremiumFeatureItem({Key? key,required this.featureName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IThemeModel _themeModel=ThemeUtil.getThemeModel(context);

    final textStyle=Theme.of(context).textTheme.subtitle1;
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: -5,horizontal: 13),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(19),
          side: BorderSide(color: textStyle?.color??Colors.black)
      ),
      tileColor: _themeModel.getGreenAccentShadeColor(),
      leading: Icon(Icons.done_outline,color: textStyle?.color,),
      title: Text(featureName,style: textStyle,),
    );
  }
}
