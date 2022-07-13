

import 'package:floor/floor.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/topic.dart';
import 'package:hadith/db/entities/helper/item_count_model.dart';

@dao
abstract class TopicDao{

  @Query("""select T.* from topic T,HadithTopic HT
     where T.id=HT.topicId and HT.hadithId=:hadithId""")
  Future<List<Topic>>getHadithTopics(int hadithId);

  @Query("""select * from topic where sectionId=:sectionId""")
  Future<List<Topic>> getTopicsWithSectionId(int sectionId);

  @Query("""select T.id,T.name,count(HT.hadithId)itemCount from 
    topic T,HadithTopic HT where T.id=HT.topicId and T.sectionId=:sectionId group by T.id""")
  Future<List<ItemCountModel>> getHadithTopicWithSectionId(int sectionId);

  @Query("""select T.id,T.name,count(HT.hadithId)itemCount from 
    topic T,HadithTopic HT where T.id=HT.topicId and T.sectionId=:sectionId and T.name like :query 
    group by T.id order by (case when T.name=:or1 then 1 when T.name like :or2 then 2 when T.name like :or3
      then 3 else 4 end )""")
  Future<List<ItemCountModel>> getSearchHadithTopicWithSectionId(int sectionId,String query,
      String or1,String or2,String or3);


  @Query("""select T.id,T.name,count(HT.hadithId)itemCount from 
    topic T,HadithTopic HT,section S where T.id=HT.topicId and S.id=T.sectionId 
    and S.bookId=:bookId group by T.id""")
  Future<List<ItemCountModel>> getHadithTopicWithBookId(int bookId);

  @Query("""select T.id,T.name,count(HT.hadithId)itemCount from 
    topic T,HadithTopic HT,Section S where T.id=HT.topicId and S.id=T.sectionId and S.bookId=:bookId and T.name like :query 
    group by T.id order by (case when T.name=:or1 then 1 when T.name like :or2 then 2 when T.name like :or3
      then 3 else 4 end )""")
  Future<List<ItemCountModel>> getSearchHadithTopicWithBookId(int bookId,String query,
      String or1,String or2,String or3);



  @Query("""select T.id,T.name,count(VT.verseId)itemCount from
    topic T,VerseTopic VT where T.id=VT.topicId and T.sectionId=:sectionId group by T.id""")
  Future<List<ItemCountModel>> getVerseTopicWithSectionId(int sectionId);

  @Query("""select T.id,T.name,count(VT.verseId)itemCount from
    topic T,VerseTopic VT where T.id=VT.topicId and T.sectionId=:sectionId and T.name like :query 
    group by T.id order by (case when T.name=:or1 then 1 when T.name like :or2 then 2 when T.name like :or3
      then 3 else 4 end )""")
  Future<List<ItemCountModel>> getSearchVerseTopicWithSectionId(int sectionId,String query,
      String or1,String or2,String or3);


  @Query("""select T.id,T.name,count(VT.verseId)itemCount from
    topic T,VerseTopic VT,Section S where T.id=VT.topicId and 
    S.id=T.sectionId and S.bookId=:bookId group by T.id""")
  Future<List<ItemCountModel>> getVerseTopicWithBookId(int bookId);

  @Query("""select T.id,T.name,count(VT.verseId)itemCount from
    topic T,VerseTopic VT,Section S where T.id=VT.topicId and S.id=T.sectionId and S.bookId=:bookId
    and T.name like :query 
    group by T.id order by (case when T.name=:or1 then 1 when T.name like :or2 then 2 when T.name like :or3
    then 3 else 4 end )""")
  Future<List<ItemCountModel>> getSearchVerseTopicWithBookId(int bookId,String query,
      String or1,String or2,String or3);


  @Query("""select S.id,S.name,count(T.id)itemCount from section S,Topic T 
      where S.id=T.sectionId and S.bookId=:bookId group by S.id""")
  Future<List<ItemCountModel>> getSectionWithBookId(int bookId);

  @Query("""select count(T.id) data from topic T,Section S where T.sectionId=S.id and S.bookId=:bookId""")
  Future<IntData?>getTopicCountsWithBookId(int bookId);

  @Query("""select S.id,S.name,count(T.id)itemCount from section S,Topic T 
      where S.id=T.sectionId and S.bookId=:bookId and S.name like :query group by S.id 
      order by (case when S.name=:or1 then 1 when S.name like :or2 then 2 when S.name like :or3
      then 3 else 4 end )""")
  Future<List<ItemCountModel>> getSearchSectionWithBookId(int bookId,String query,
      String or1,String or2,String or3);

}