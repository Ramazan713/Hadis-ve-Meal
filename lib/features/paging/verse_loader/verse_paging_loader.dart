import 'package:flutter/material.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/verse.dart';

import 'i_paging_verse_loader.dart';

class VersePagingLoader extends IPagingVerseLoader{

  VersePagingLoader({required BuildContext context}):super(context);
  @override
  Future<IntData?> getPagingCount() {
    return verseRepo.getPagingCount();
  }

  @override
  Future<List<Verse>> getVerses(int limit, int page) {
    return verseRepo.getPagingVerses(limit, page);
  }

}