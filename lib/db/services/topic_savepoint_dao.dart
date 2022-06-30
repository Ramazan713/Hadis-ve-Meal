

import 'package:floor/floor.dart';
import 'package:hadith/db/entities/topic_savepoint_entity.dart';

@dao
abstract class TopicSavePointDao{

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int>insertTopicSavePoint(TopicSavePointEntity topicSavePointEntity);

  @Update()
  Future<int>updateTopicSavePoint(TopicSavePointEntity topicSavePointEntity);

  @delete
  Future<int>deleteTopicSavePoint(TopicSavePointEntity topicSavePointEntity);

  @Query("""select * from topicSavePoint where type=:type and parentKey=:parentKey
     order by id desc limit 1""")
  Stream<TopicSavePointEntity?>getStreamTopicSavePointEntity(int type,
      String parentKey);

  @Query("""select * from topicSavePoint where type=:type and parentKey=:parentKey
     order by id desc limit 1""")
  Future<TopicSavePointEntity?>getTopicSavePointEntity(int type,
      String parentKey);


}