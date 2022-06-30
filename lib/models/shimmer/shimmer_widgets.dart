

import 'package:flutter/material.dart';
import 'package:hadith/models/shimmer/shimmer_hadith_item.dart';
import 'package:hadith/models/shimmer/shimmer_list_item.dart';
import 'package:hadith/models/shimmer/shimmer_topic_item.dart';
import 'package:hadith/models/shimmer/shimmer_verse_item.dart';
import 'package:hadith/utils/theme_util.dart';
import 'package:shimmer/shimmer.dart';

Widget getVerseShimmer(BuildContext context){
  final themeModel=ThemeUtil.getThemeModel(context);
  return SizedBox(
      height: 110,
      width: double.infinity,
      child: Shimmer.fromColors(
          baseColor: themeModel.getVerseBaseShimmerColor(),
          highlightColor: themeModel.getVerseHighlightShimmerColor(),
          child: const ShimmerVerseItem())
  );
}

Widget getHadithShimmer(BuildContext context){
  final themeModel=ThemeUtil.getThemeModel(context);

  return Shimmer.fromColors(
      baseColor: themeModel.getHadithBaseShimmerColor(),
      highlightColor: themeModel.getHadithHighlightShimmerColor(),
      child: const ShimmerHadithItem());
}

Widget getTopicShimmer(BuildContext context){
  final themeModel=ThemeUtil.getThemeModel(context);

  return Shimmer.fromColors(
      baseColor: themeModel.getHadithBaseShimmerColor(),
      highlightColor: themeModel.getHadithHighlightShimmerColor(),
      child: const ShimmerTopicItem());
}

Widget getListShimmer(BuildContext context){
  final themeModel=ThemeUtil.getThemeModel(context);

  return Shimmer.fromColors(
      baseColor: themeModel.getHadithBaseShimmerColor(),
      highlightColor: themeModel.getHadithHighlightShimmerColor(),
      child: const ShimmerListItem());
}

