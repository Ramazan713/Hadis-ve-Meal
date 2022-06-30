import 'package:floor/floor.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/hadith.dart';


@dao
abstract class HadithDao{

  @Query("select * from hadith")
  Stream<List<Hadith>> getStreamAllHadiths();

  @Query("select H.* from Hadith H,ListHadith LH where LH.hadithId=H.id and LH.listId=:listId")
  Stream<List<Hadith>> getStreamHadithsWithListId(int listId);

  @Query("select H.* from Hadith H,HadithTopic HT where HT.hadithId=H.id and HT.topicId=:topicId")
  Stream<List<Hadith>> getStreamHadithsWithTopicId(int topicId);


  @Query("select count(*) data from hadith")
  Future<IntData?> getAllHadithCount();

  @Query("select row_number() over() rowNumber,* from hadith limit :limit offset :limit * ((:page) -1)")
  Future<List<Hadith>>getPagingAllHadiths(int limit,int page);


  @Query("select count(*) data from hadith where bookId=:bookId")
  Future<IntData?> getHadithBookCount(int bookId);

  @Query("""select row_number() over() rowNumber,* from hadith where bookId=:bookId  limit :limit offset :limit * ((:page) -1)""")
  Future<List<Hadith>>getPagingBookHadiths(int limit,int page,int bookId);


  @Query("""select count(H.id) data from Hadith H,ListHadith LH
     where LH.hadithId=H.id and LH.listId=:listId""")
  Future<IntData?> getListWithHadithCount(int listId);

  @Query("""select row_number() over(order by
      LH.pos desc) rowNumber,H.* from Hadith H,ListHadith LH
     where LH.hadithId=H.id and LH.listId=:listId order by
      LH.pos desc limit :limit offset :limit * ((:page) -1)
     """)
  Future<List<Hadith>>getPagingListHadiths(int limit,int page,int listId);


  @Query("""select row_number() over(order by
      LH.pos desc) rowNumber,H.* from Hadith H,ListHadith LH
     where LH.hadithId=H.id and LH.listId=:listId order by
      LH.pos desc
     """)
  Future<List<Hadith>>getListHadiths(int listId);


  @Query("""select count(H.id) data from Hadith H,HadithTopic HT
     where HT.hadithId=H.id and HT.topicId=:topicId""")
  Future<IntData?> getTopicWithHadithCount(int topicId);

  @Query("""select row_number() over() rowNumber,H.* from Hadith H,HadithTopic HT
     where HT.hadithId=H.id and HT.topicId=:topicId limit :limit offset :limit * ((:page) -1)
     """)
  Future<List<Hadith>>getPagingTopicHadiths(int limit,int page,int topicId);



  @Query("""select count(id) data from Hadith where lower(content)  REGEXP lower(:regExp)""")
  Future<IntData?> getSearchWithHadithCountWithRegEx(String regExp);

  @Query("""select row_number() over() rowNumber,* from Hadith where lower(content)  REGEXP lower(:regExp)
      limit :limit offset :limit * ((:page) -1)""")
  Future<List<Hadith>>getPagingSearchHadithsWithRegEx(int limit,int page,String regExp);


  @Query("""select count(id) data from Hadith where bookId=:bookId and lower(content)  REGEXP lower(:regExp)""")
  Future<IntData?> getSearchHadithCountWithBookAndRegEx(String regExp,int bookId);

  @Query("""select row_number() over() rowNumber,* from Hadith where bookId=:bookId and
      lower(content)  REGEXP lower(:regExp) limit :limit offset :limit * ((:page) -1)""")
  Future<List<Hadith>>getPagingSearchHadithsWithBookAndRegEx(int limit,int page,int bookId,String regExp);


  @Query("""select count(id) data from Hadith where lower(content) Like lower(:query)""")
  Future<IntData?> getSearchWithHadithCount(String query);

  @Query("""select row_number() over() rowNumber,* from Hadith where lower(content) Like lower(:query)
      limit :limit offset :limit * ((:page) -1)""")
  Future<List<Hadith>>getPagingSearchHadiths(int limit,int page,String query);


  @Query("""select count(id) data from Hadith where bookId=:bookId and lower(content)  Like lower(:query)""")
  Future<IntData?> getSearchHadithCountWithBook(String query,int bookId);

  @Query("""select row_number() over() rowNumber,* from Hadith where bookId=:bookId and
      lower(content) Like lower(:query) limit :limit offset :limit * ((:page) -1)""")
  Future<List<Hadith>>getPagingSearchHadithsWithBook(int limit,int page,int bookId,String query);






}