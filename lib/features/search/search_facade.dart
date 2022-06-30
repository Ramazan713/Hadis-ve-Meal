import 'package:hadith/db/entities/hadith.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/db/repos/hadith_repo.dart';
import 'package:hadith/db/repos/verse_repo.dart';

class SearchFacade{
  final HadithRepo hadithRepo;
  final VerseRepo verseRepo;

  SearchFacade({required this.verseRepo,required this.hadithRepo});

  Future<IntData?> getSearchWithHadithCount(String query,bool isRegEx){
    return isRegEx?hadithRepo.getSearchWithHadithCountWithRegEx(query):
        hadithRepo.getSearchWithHadithCount(query);
  }

  Future<List<Hadith>> getPagingSearchHadiths(int limit, int page, String query,bool isRegEx){
    return isRegEx?hadithRepo.getPagingSearchHadithsWithRegEx(limit,page,query):
        hadithRepo.getPagingSearchHadiths(limit,page,query);
  }

  Future<IntData?> getSearchHadithCountWithBook(String query, int bookId,bool isRegEx){
    return isRegEx?hadithRepo.getSearchHadithCountWithBookAndRegEx(query,bookId):
      hadithRepo.getSearchHadithCountWithBook(query,bookId);
  }

  Future<List<Hadith>> getPagingSearchHadithsWithBook(int limit, int page, int bookId, String query,bool isRegEx){
    return isRegEx?hadithRepo.getPagingSearchHadithsWithBookAndRegEx(limit,page,bookId,query):
    hadithRepo.getPagingSearchHadithsWithBook(limit,page,bookId,query);
  }


  Future<IntData?> getSearchWithVerseCount(String query,bool isRegEx)=>
      isRegEx?verseRepo.getSearchWithVerseCountWithRegEx(query):verseRepo.getSearchWithVerseCount(query);

  Future<List<Verse>>getPagingSearchVerses(int limit,int page,String query,bool isRegEx)=>
      isRegEx?verseRepo.getPagingSearchVersesWithRegEx(limit,page,query):verseRepo.getPagingSearchVerses(limit,page,query);
}