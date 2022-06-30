import 'package:flutter/material.dart';
import 'package:hadith/db/entities/helper/int_data.dart';

import 'package:hadith/db/entities/hadith.dart';

import 'i_paging_hadith_loader.dart';

class HadithTopicPagingLoader extends IPagingHadithLoader{
  final int topicId;

  HadithTopicPagingLoader({required BuildContext context,required this.topicId}):
      super(context);

  @override
  Future<List<Hadith>> getHadiths(int limit, int page) {
   return hadithRepo.getPagingTopicHadiths(limit, page, topicId);
  }

  @override
  Future<IntData?> getPagingCount() {
    return hadithRepo.getTopicWithHadithCount(topicId);
  }

}