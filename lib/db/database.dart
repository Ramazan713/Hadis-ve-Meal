
import 'dart:async';
import 'dart:typed_data';
import 'package:floor/floor.dart';
import 'package:hadith/db/converter/origintag_converter.dart';
import 'package:hadith/db/converter/topic_savepoint_converter.dart';
import 'package:hadith/db/entities/backup_meta.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/history_entity.dart';
import 'package:hadith/db/entities/savepoint.dart';
import 'package:hadith/db/entities/savepoint_type_entity.dart';
import 'package:hadith/db/entities/topic_savepoint_entity.dart';
import 'package:hadith/db/entities/user_info_entity.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';
import 'package:hadith/db/services/backup_dao.dart';
import 'package:hadith/db/services/backup_meta_dao.dart';
import 'package:hadith/db/services/history_dao.dart';
import 'package:hadith/db/services/save_point_dao.dart';
import 'package:hadith/db/services/section_dao.dart';
import 'package:hadith/db/services/topic_dao.dart';
import 'package:hadith/db/entities/helper/item_count_model.dart';
import 'package:hadith/db/services/topic_savepoint_dao.dart';
import 'package:hadith/db/services/user_info_dao.dart';
import 'entities/hadith_topic.dart';
import 'entities/list_hadith_entity.dart';
import 'entities/list_verse_entity.dart';
import 'entities/source_type_entity.dart';
import 'entities/verse_topic.dart';
import 'entities/book.dart';
import 'entities/hadith.dart';
import 'entities/cuz.dart';
import 'entities/list_entity.dart';
import 'entities/section.dart';
import 'entities/surah.dart';
import 'entities/topic.dart';
import 'entities/verse.dart';
import 'entities/views/list_hadith_view.dart';
import 'entities/views/list_verse_view.dart';
import 'services/hadith_dao.dart';
import 'services/cuz_dao.dart';
import 'services/list_dao.dart';
import 'services/surah_dao.dart';
import 'services/verse_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


part 'database.g.dart';
@TypeConverters([OriginTagConverter,TopicSavePointConverter])
@Database(version: 1,
    entities: [Hadith,Cuz,Surah,Topic,Verse,Section,IntData,SavePoint,SavePointTypeEntity,
      BackupMeta,TopicSavePointEntity,HistoryEntity,UserInfoEntity,IListView,
      ListEntity,SourceTypeEntity,ItemCountModel,VerseTopic,ListHadithEntity,ListVerseEntity,HadithTopic,Book],
    views: [ListVerseView,ListHadithView])
abstract class AppDatabase extends FloorDatabase{
  HadithDao get hadithDao;
  CuzDao get cuzDao;
  ListDao get listDao;
  SurahDao get surahDao;
  VerseDao get verseDao;
  TopicDao get topicDao;
  SectionDao get sectionDao;
  SavePointDao get savePointDao;
  TopicSavePointDao get topicSavePointDao;
  HistoryDao get historyDao;
  BackupMetaDao get backupMetaDao;
  BackupDao get backupDao;
  UserInfoDao get userInfoDao;
}
