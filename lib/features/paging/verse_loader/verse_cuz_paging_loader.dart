import 'package:flutter/material.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/features/paging/verse_loader/i_paging_verse_loader.dart';

class VerseCuzPagingLoader extends IPagingVerseLoader{
  final int cuzNo;
  VerseCuzPagingLoader({required BuildContext context,required this.cuzNo}):super(context);

  @override
  Future<IntData?> getPagingCount() {
    return verseRepo.getPagingCuzVersesCount(cuzNo);
  }

  @override
  Future<List<Verse>> getVerses(int limit, int page) {
    return verseRepo.getPagingCuzVerses(limit, page, cuzNo);
  }

}