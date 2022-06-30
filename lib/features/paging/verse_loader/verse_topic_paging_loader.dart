import 'package:flutter/material.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/verse.dart';

import 'i_paging_verse_loader.dart';

class VerseTopicPagingLoader extends IPagingVerseLoader{
  final int topicId;

  VerseTopicPagingLoader({required BuildContext context,required this.topicId}):super(context);

  @override
  Future<IntData?> getPagingCount() {
    return verseRepo.getPagingTopicVersesCount(topicId);
  }
  @override
  Future<List<Verse>> getVerses(int limit, int page) {
    return verseRepo.getPagingTopicVerses(limit, page, topicId);
  }

}