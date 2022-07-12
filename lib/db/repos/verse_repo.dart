

import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/db/entities/verse_arabic.dart';
import 'package:hadith/db/services/verse_dao.dart';

class VerseRepo{
  final VerseDao verseDao;

  VerseRepo({required this.verseDao});

  Future<List<Verse>> getVersesWithSurahId(int surahId)=>verseDao.getVersesWithSurahId(surahId);

  Future<List<Verse>> getVersesWithCuzNo(int cuzNo)=>verseDao.getVersesWithCuzNo(cuzNo);


  Future<List<Verse>>getPagingVerses(int limit,int page)=>verseDao.getPagingVerses(limit, page);

  Future<IntData?>getPagingCount()=>verseDao.getPagingCount();


  Future<List<Verse>>getPagingTopicVerses(int limit,int page,int topicId)=>
      verseDao.getPagingTopicVerses(limit, page, topicId);

  Future<IntData?>getPagingTopicVersesCount(int topicId)=>
      verseDao.getPagingTopicVersesCount(topicId);


  Future<List<Verse>>getPagingSurahVerses(int limit,int page,int surahId)=>
      verseDao.getPagingSurahVerses(limit, page, surahId);

  Future<IntData?>getPagingSurahVersesCount(int surahId)=>
      verseDao.getPagingSurahVersesCount(surahId);


  Future<List<Verse>>getPagingCuzVerses(int limit,int page,int cuzNo)=>
      verseDao.getPagingCuzVerses(limit, page, cuzNo);

  Future<IntData?>getPagingCuzVersesCount(int cuzNo)=>
      verseDao.getPagingCuzVersesCount(cuzNo);


  Future<List<Verse>>getPagingListVerses(int limit,int page,int listId)=>
      verseDao.getPagingListVerses(limit, page, listId);

  Future<IntData?>getPagingListVersesCount(int listId)=>
      verseDao.getPagingListVersesCount(listId);

  Future<List<Verse>>getListVerses(int listId)=>verseDao.getListVerses(listId);


  Future<IntData?> getSearchWithVerseCountWithRegEx(String query){
    final regExp="${query.split(' ').map((e) => "(?=.*$e)").join('')}.*";
    return verseDao.getSearchWithVerseCountWithRegEx(regExp);
  }


  Future<List<Verse>>getPagingSearchVersesWithRegEx(int limit,int page,String query){
    final regExp="${query.split(' ').map((e) => "(?=.*$e)").join('')}.*";
    return verseDao.getPagingSearchVersesWithRegEx(limit, page,regExp);
  }


  Future<IntData?> getSearchWithVerseCount(String query)=>
      verseDao.getSearchWithVerseCount("%$query%");

  Future<List<Verse>>getPagingSearchVerses(int limit,int page,String query)=>
      verseDao.getPagingSearchVerses(limit, page, "%$query%");

  Future<List<VerseArabic>>getArabicVersesWithId(int mealId)=>
      verseDao.getArabicVersesWithId(mealId);

}