

import 'package:hadith/constants/enums/topic_savepoint_enum.dart';
import 'package:hadith/db/entities/topic_savepoint_entity.dart';
import 'package:hadith/db/services/topic_savepoint_dao.dart';

class TopicSavePointRepo{
  final TopicSavePointDao savePointDao;

  TopicSavePointRepo({required this.savePointDao});

  Future<int>insertTopicSavePoint(TopicSavePointEntity topicSavePointEntity)=>
      savePointDao.insertTopicSavePoint(topicSavePointEntity);

  Future<int>updateTopicSavePoint(TopicSavePointEntity topicSavePointEntity)=>
      savePointDao.updateTopicSavePoint(topicSavePointEntity);

  Future<int>deleteTopicSavePoint(TopicSavePointEntity topicSavePointEntity)=>
      savePointDao.deleteTopicSavePoint(topicSavePointEntity);

  Stream<TopicSavePointEntity?>getStreamTopicSavePointEntity(TopicSavePointEnum topicSavePointEnum,
      String parentKey)=>savePointDao.getStreamTopicSavePointEntity(topicSavePointEnum.type, parentKey);

  Future<TopicSavePointEntity?>getTopicSavePointEntity(TopicSavePointEnum topicSavePointEnum,
      String parentKey)=>savePointDao.getTopicSavePointEntity(topicSavePointEnum.type, parentKey);

}