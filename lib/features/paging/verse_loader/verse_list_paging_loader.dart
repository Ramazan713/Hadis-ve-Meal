import 'package:flutter/material.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/features/paging/mixin/list_mixin.dart';
import 'package:hadith/features/paging/verse_loader/i_paging_verse_loader.dart';

class VerseListPagingLoader extends IPagingVerseLoader with ListMixinLoader{

  VerseListPagingLoader({required BuildContext context,required int listId}):super(context){
    this.listId=listId;
  }

  @override
  Future<IntData?> getPagingCount() {
    return verseRepo.getPagingListVersesCount(listId);
  }

  @override
  Future<List<Verse>> getVerses(int limit, int page) {
    return verseRepo.getPagingListVerses(limit, page, listId);
  }

}