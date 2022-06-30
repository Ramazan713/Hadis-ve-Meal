import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/db/repos/hadith_repo.dart';
import 'package:flutter/material.dart';
import '../../../utils/search_criteria_helper.dart';
import '../../search/search_facade.dart';
import 'i_paging_verse_loader.dart';

class VerseSearchPagingLoader extends IPagingVerseLoader{
  final String searchKey;
  late final SearchFacade _searchFacade;

  VerseSearchPagingLoader(BuildContext context,{required this.searchKey}) : super(context){
    _searchFacade=SearchFacade(verseRepo: verseRepo, hadithRepo:  context.read<HadithRepo>());

  }

  @override
  Future<IntData?> getPagingCount() {
    final isRegEx = SearchCriteriaHelper.isRegEx();
    return _searchFacade.getSearchWithVerseCount(searchKey, isRegEx);
  }

  @override
  Future<List<Verse>> getVerses(int limit, int page) {
    final isRegEx = SearchCriteriaHelper.isRegEx();
    return _searchFacade.getPagingSearchVerses(limit, page, searchKey, isRegEx);
  }

}