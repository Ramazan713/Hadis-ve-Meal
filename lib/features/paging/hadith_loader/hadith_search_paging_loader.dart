
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/utils/search_criteria_helper.dart';
import 'package:hadith/db/entities/hadith.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/repos/verse_repo.dart';
import 'package:hadith/features/search/search_facade.dart';
import 'i_paging_hadith_loader.dart';

class HadithSearchPagingLoader extends IPagingHadithLoader{
  final String searchKey;
  late final SearchFacade _searchFacade;

  HadithSearchPagingLoader(BuildContext context,{required this.searchKey}) : super(context){
    _searchFacade=SearchFacade(verseRepo: context.read<VerseRepo>(), hadithRepo: hadithRepo);
  }

  @override
  Future<List<Hadith>> getHadiths(int limit, int page){
    final isRegEx = SearchCriteriaHelper.isRegEx();
    return _searchFacade.getPagingSearchHadiths(limit, page,searchKey, isRegEx);
  }

  @override
  Future<IntData?> getPagingCount(){
    final isRegEx = SearchCriteriaHelper.isRegEx();
    return _searchFacade.getSearchWithHadithCount(searchKey,isRegEx);
  }

}