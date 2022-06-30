import 'package:flutter/material.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/verse.dart';

import 'i_paging_verse_loader.dart';

class VerseSurahPagingLoader extends IPagingVerseLoader{
  final int surahId;

  VerseSurahPagingLoader({required BuildContext context,required this.surahId}):super(context);

  @override
  Future<IntData?> getPagingCount() {
    return verseRepo.getPagingSurahVersesCount(surahId);
  }

  @override
  Future<List<Verse>> getVerses(int limit, int page) {
    return verseRepo.getPagingSurahVerses(limit, page, surahId);
  }

}