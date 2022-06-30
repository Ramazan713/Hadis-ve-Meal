import 'package:hadith/db/entities/hadith.dart';
import 'package:hadith/db/services/hadith_dao.dart';

import '../entities/helper/int_data.dart';

class HadithRepo {
  final HadithDao hadithDao;
  HadithRepo({required this.hadithDao});

  Stream<List<Hadith>> getStreamAllHadiths() => hadithDao.getStreamAllHadiths();

  Stream<List<Hadith>> getStreamHadithsWithListId(int listId) =>
      hadithDao.getStreamHadithsWithListId(listId);

  Stream<List<Hadith>> getStreamHadithsWithTopicId(int topicId) =>
      hadithDao.getStreamHadithsWithTopicId(topicId);

  Future<IntData?> getAllHadithCount() => hadithDao.getAllHadithCount();
  Future<List<Hadith>> getPagingAllHadiths(int limit, int page) =>
      hadithDao.getPagingAllHadiths(limit, page);

  Future<IntData?> getListWithHadithCount(int listId) =>
      hadithDao.getListWithHadithCount(listId);
  Future<List<Hadith>> getPagingListHadiths(int limit, int page, int listId) =>
      hadithDao.getPagingListHadiths(limit, page, listId);

  Future<List<Hadith>>getListHadiths(int listId)=>hadithDao.getListHadiths(listId);

  Future<IntData?> getTopicWithHadithCount(int topicId) =>
      hadithDao.getTopicWithHadithCount(topicId);
  Future<List<Hadith>> getPagingTopicHadiths(
          int limit, int page, int topicId) =>
      hadithDao.getPagingTopicHadiths(limit, page, topicId);

  Future<IntData?> getHadithBookCount(int bookId) =>
      hadithDao.getHadithBookCount(bookId);
  Future<List<Hadith>> getPagingBookHadiths(int limit, int page, int bookId) =>
      hadithDao.getPagingBookHadiths(limit, page, bookId);

  Future<IntData?> getSearchWithHadithCountWithRegEx(String query) {
    final regExp = "${query.split(' ').map((e) => "(?=.*$e)").join('')}.*";
    return hadithDao.getSearchWithHadithCountWithRegEx(regExp);
  }

  Future<List<Hadith>> getPagingSearchHadithsWithRegEx(
      int limit, int page, String query) {
    final regExp = "${query.split(' ').map((e) => "(?=.*$e)").join('')}.*";
    return hadithDao.getPagingSearchHadithsWithRegEx(limit, page, regExp);
  }

  Future<IntData?> getSearchHadithCountWithBookAndRegEx(String query, int bookId) {
    final regExp = "${query.split(' ').map((e) => "(?=.*$e)").join('')}.*";
    return hadithDao.getSearchHadithCountWithBookAndRegEx(regExp, bookId);
  }

  Future<List<Hadith>> getPagingSearchHadithsWithBookAndRegEx(
      int limit, int page, int bookId, String query) {
    final regExp = "${query.split(' ').map((e) => "(?=.*$e)").join('')}.*";
    return hadithDao.getPagingSearchHadithsWithBookAndRegEx(
        limit, page, bookId, regExp);
  }


  Future<IntData?> getSearchWithHadithCount(String query)=>
      hadithDao.getSearchWithHadithCount("%$query%");

  Future<List<Hadith>>getPagingSearchHadiths(int limit,int page,String query)=>
      hadithDao.getPagingSearchHadiths(limit, page, "%$query%");

  Future<IntData?> getSearchHadithCountWithBook(String query,int bookId)=>
      hadithDao.getSearchHadithCountWithBook("%$query%", bookId);

  Future<List<Hadith>>getPagingSearchHadithsWithBook(int limit,int page,int bookId,String query)=>
      hadithDao.getPagingSearchHadithsWithBook(limit, page, bookId, "%$query%");


}
