import 'package:floor/floor.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/verse.dart';


@dao
abstract class VerseDao{

  @Query("select * from verse where surahId=:surahId")
  Future<List<Verse>> getVersesWithSurahId(int surahId);

  @Query("select * from verse where cuzNo=:cuzNo")
  Future<List<Verse>> getVersesWithCuzNo(int cuzNo);


  @Query("""select row_number() over(partition by pageNo)pageRank,
      row_number() over() rowNumber,
      V.*,S.name surahName from verse V,Surah S
       where V.surahId=S.id limit :limit offset :limit*((:page)-1)""")
  Future<List<Verse>>getPagingVerses(int limit,int page);

  @Query("select count(*) data from verse")
  Future<IntData?>getPagingCount();


  @Query("""select row_number() over(partition by pageNo)pageRank,
      row_number() over() rowNumber,
      V.*,S.name surahName from verse V,Surah S,VerseTopic VT
       where V.surahId=S.id and VT.verseId=V.id and VT.topicId=:topicId
       limit :limit offset :limit*((:page)-1)""")
  Future<List<Verse>>getPagingTopicVerses(int limit,int page,int topicId);

  @Query("select count(*) data from verse V,VerseTopic VT where VT.verseId=V.id and VT.topicId=:topicId")
  Future<IntData?>getPagingTopicVersesCount(int topicId);


  @Query("""select row_number() over(partition by pageNo)pageRank,
      row_number() over() rowNumber,
      V.*,S.name surahName from verse V,Surah S
       where V.surahId=S.id and S.id=:surahId limit :limit offset :limit*((:page)-1)""")
  Future<List<Verse>>getPagingSurahVerses(int limit,int page,int surahId);

  @Query("select count(*) data from verse V,Surah S where V.surahId=S.id and V.surahId=:surahId")
  Future<IntData?>getPagingSurahVersesCount(int surahId);


  @Query("""select row_number() over(partition by pageNo)pageRank,
      row_number() over() rowNumber,
      V.*,S.name surahName from verse V,Surah S,Cuz C
       where V.surahId=S.id and C.cuzNo=V.cuzNo and V.cuzNo=:cuzNo limit :limit offset :limit*((:page)-1)""")
  Future<List<Verse>>getPagingCuzVerses(int limit,int page,int cuzNo);

  @Query("select count(*) data from verse V,Cuz C where C.cuzNo=V.cuzNo and V.cuzNo=:cuzNo")
  Future<IntData?>getPagingCuzVersesCount(int cuzNo);


  @Query("""select row_number() over(partition by pageNo)pageRank,
      row_number() over(order by LV.pos desc) rowNumber,
      V.*,S.name surahName from verse V,Surah S,ListVerse LV
      where V.surahId=S.id and LV.verseId=V.id and LV.listId=:listId order by LV.pos desc limit :limit offset :limit*((:page)-1)
      """)
  Future<List<Verse>>getPagingListVerses(int limit,int page,int listId);

  @Query("select count(*) data from verse V,ListVerse LV where LV.verseId=V.id and LV.listId=:listId")
  Future<IntData?>getPagingListVersesCount(int listId);


  @Query("""select row_number() over(partition by pageNo)pageRank,
      row_number() over(order by LV.pos desc) rowNumber,
      V.*,S.name surahName from verse V,Surah S,ListVerse LV
      where V.surahId=S.id and LV.verseId=V.id and LV.listId=:listId order by LV.pos desc
      """)
  Future<List<Verse>>getListVerses(int listId);



  @Query("""select count(id) data from verse V where lower(content)  REGEXP lower(:regExp) """)
  Future<IntData?> getSearchWithVerseCountWithRegEx(String regExp);

  @Query("""select row_number() over(partition by pageNo)pageRank,
      row_number() over() rowNumber,
      V.*,S.name surahName from verse V,Surah S
      where V.surahId=S.id and  lower(content)  REGEXP lower(:regExp)
      limit :limit offset :limit * ((:page) -1)""")
  Future<List<Verse>>getPagingSearchVersesWithRegEx(int limit,int page,String regExp);


  @Query("""select count(id) data from verse V where lower(content) Like lower(:query) """)
  Future<IntData?> getSearchWithVerseCount(String query);

  @Query("""select row_number() over(partition by pageNo)pageRank,
      row_number() over() rowNumber,
      V.*,S.name surahName from verse V,Surah S
      where V.surahId=S.id and  lower(content)  Like lower(:query)
      limit :limit offset :limit * ((:page) -1)""")
  Future<List<Verse>>getPagingSearchVerses(int limit,int page,String query);




}