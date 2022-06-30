

import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/topic.dart';
import 'package:hadith/db/services/topic_dao.dart';
import 'package:hadith/db/entities/helper/item_count_model.dart';

class TopicRepo{
  final TopicDao topicDao;

  TopicRepo({required this.topicDao});

  Future<List<Topic>> getTopicsWithSectionId(int sectionId)=>
      topicDao.getTopicsWithSectionId(sectionId);

  Future<List<ItemCountModel>> getHadithTopicWithSectionId(int sectionId)=>
      topicDao.getHadithTopicWithSectionId(sectionId);

  Future<List<ItemCountModel>> getSearchHadithTopicWithSectionId(int sectionId,String query)=>
      topicDao.getSearchHadithTopicWithSectionId(sectionId, "%$query%", query, "$query%", "%$query");


  Future<List<ItemCountModel>> getHadithTopicWithBookId(int bookId)=>
      topicDao.getHadithTopicWithBookId(bookId);

  Future<List<ItemCountModel>> getSearchHadithTopicWithBookId(int bookId,String query)=>
      topicDao.getSearchHadithTopicWithBookId(bookId,"%$query%", query, "$query%", "%$query");


  Future<List<ItemCountModel>> getVerseTopicWithSectionId(int sectionId)=>
      topicDao.getVerseTopicWithSectionId(sectionId);

  Future<List<ItemCountModel>> getSearchVerseTopicWithSectionId(int sectionId,String query)=>
      topicDao.getSearchVerseTopicWithSectionId(sectionId, "%$query%", query, "$query%", "%$query");

  Future<List<Topic>>getHadithTopics(int hadithId)=>topicDao.getHadithTopics(hadithId);


  Future<List<ItemCountModel>> getVerseTopicWithBookId(int bookId)=>
      topicDao.getVerseTopicWithBookId(bookId);

  Future<List<ItemCountModel>> getSearchVerseTopicWithBookId(int bookId,String query)=>
      topicDao.getSearchVerseTopicWithBookId(bookId,"%$query%", query, "$query%", "%$query");


  Future<IntData?>getTopicCountsWithBookId(int bookId)=>topicDao.getTopicCountsWithBookId(bookId);

  Future<List<ItemCountModel>> getSectionWithBookId(int bookId)=>topicDao.getSectionWithBookId(bookId);

  Future<List<ItemCountModel>> getSearchSectionWithBookId(int bookId,String query)=>
      topicDao.getSearchSectionWithBookId(bookId, "%$query%", query, "$query%", "%$query");
}