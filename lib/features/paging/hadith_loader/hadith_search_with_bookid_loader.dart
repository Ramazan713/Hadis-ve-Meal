

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/utils/search_criteria_helper.dart';
import 'package:hadith/db/entities/hadith.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/repos/verse_repo.dart';
import 'package:hadith/features/search/search_facade.dart';
import 'package:hadith/features/paging/hadith_loader/i_paging_hadith_loader.dart';

class HadithSearchBookIdLoader extends IPagingHadithLoader{
  final String searchKey;
  final int bookId;
  late final SearchFacade _searchFacade;

  HadithSearchBookIdLoader(BuildContext context,{required this.searchKey,
    required this.bookId})
      : super(context){
    _searchFacade=SearchFacade(verseRepo: context.read<VerseRepo>(), hadithRepo: hadithRepo);
  }

  @override
  Future<List<Hadith>> getHadiths(int limit, int page) {
    final isRegEx = SearchCriteriaHelper.isRegEx();
    return _searchFacade.getPagingSearchHadithsWithBook(limit, page, bookId, searchKey,isRegEx);
  }

  @override
  Future<IntData?> getPagingCount() {
    final isRegEx = SearchCriteriaHelper.isRegEx();
    return _searchFacade.getSearchHadithCountWithBook(searchKey,bookId,isRegEx);
  }
}