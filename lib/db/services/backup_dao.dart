import 'package:floor/floor.dart';
import 'package:hadith/db/entities/savepoint.dart';
import 'package:hadith/db/entities/topic_savepoint_entity.dart';
import '../entities/history_entity.dart';
import '../entities/list_entity.dart';
import '../entities/list_hadith_entity.dart';
import '../entities/list_verse_entity.dart';

@dao
abstract class BackupDao{

  @Query("""select * from history""")
  Future<List<HistoryEntity>>getHistories();

  @Query("""select * from list where isRemovable=1""")
  Future<List<ListEntity>>getLists();

  @Query("""select * from ListHadith""")
  Future<List<ListHadithEntity>>getHadithListEntities();

  @Query("""select * from listVerse""")
  Future<List<ListVerseEntity>>getVerseListEntities();

  @Query("""select * from savepoint""")
  Future<List<SavePoint>>getSavePoints();

  @Query("""select * from topicSavePoint""")
  Future<List<TopicSavePointEntity>>getTopicSavePoints();



  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>>insertHistories(List<HistoryEntity>histories);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>>insertLists(List<ListEntity>lists);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>>insertHadithLists(List<ListHadithEntity>hadithLists);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>>insertVerseLists(List<ListVerseEntity>verseLists);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>>insertSavePoints(List<SavePoint>savePoints);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>>insertTopicSavePoints(List<TopicSavePointEntity>topicSavePoints);


  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int>insertHistory(HistoryEntity history);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int>insertList(ListEntity list);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int>insertHadithList(ListHadithEntity hadithList);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int>insertVerseList(ListVerseEntity verseList);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int>insertSavePoint(SavePoint savePoint);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int>insertTopicSavePoint(TopicSavePointEntity topicSavePoint);



  @Query("""delete from history""")
  Future<void> deleteHistories();

  @Query("""delete from list where isRemovable=1""")
  Future<void> deleteLists();

  @Query("""delete from ListHadith""")
  Future<void> deleteHadithLists();

  @Query("""delete from listVerse""")
  Future<void> deleteVerseLists();

  @Query("""delete from savepoint""")
  Future<void> deleteSavePoints();

  @Query("""delete from topicSavePoint""")
  Future<void> deleteTopicSavePoints();

}