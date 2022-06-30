import 'dart:convert';
import 'dart:typed_data';
import 'package:hadith/constants/preference_constants.dart';
import 'package:hadith/db/entities/history_entity.dart';
import 'package:hadith/db/entities/list_entity.dart';
import 'package:hadith/db/entities/list_hadith_entity.dart';
import 'package:hadith/db/entities/list_verse_entity.dart';
import 'package:hadith/db/entities/topic_savepoint_entity.dart';
import 'package:hadith/db/services/backup_dao.dart';
import 'package:hadith/utils/localstorage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entities/savepoint.dart';

class BackupRepo{
  final BackupDao backupDao;
  BackupRepo({required this.backupDao});

  Future<void>deleteAllData()async{
    await backupDao.deleteHadithLists();
    await backupDao.deleteLists();
    await backupDao.deleteSavePoints();
    await backupDao.deleteTopicSavePoints();
    await backupDao.deleteVerseLists();
    await backupDao.deleteHistories();
  }

  Future<String>getJsonData()async{
    final hadithLists=await backupDao.getHadithListEntities();
    final lists=await backupDao.getLists();
    final savePoints=await backupDao.getSavePoints();
    final topicSavePoints=await backupDao.getTopicSavePoints();
    final verseLists=await backupDao.getVerseListEntities();
    final histories=await backupDao.getHistories();

    final hadithListJsonArr=hadithLists.map((e) => e.toJson()).toList();
    final listsJsonArr=lists.map((e) => e.toJson()).toList();
    final savePointsJsonArr=savePoints.map((e) => e.toJson()).toList();
    final topicSavePointsJsonArr=topicSavePoints.map((e) => e.toJson()).toList();
    final verseListJsonArr=verseLists.map((e) => e.toJson()).toList();
    final historiesJsonArr=histories.map((e) => e.toJson()).toList();

    final SharedPreferences sharedPreferences=LocalStorage.sharedPreferences;
    final sharedJsonArr=PrefConstants.values().map((e) => {"key":e.key,"type":e.type.toString(),"value":sharedPreferences.get(e.key)})
      .map((e) => json.encode(e)).toList();

    final packageInfo=await PackageInfo.fromPlatform();

    final resultMap={
      "info":{"version":packageInfo.version,"buildNumber":packageInfo.buildNumber},
      "history":historiesJsonArr,
      "list":listsJsonArr,
      "listHadith":hadithListJsonArr,
      "listVerse":verseListJsonArr,
      "savePoint":savePointsJsonArr,
      "topicSavePoint":topicSavePointsJsonArr,
      "sharedPreferences":sharedJsonArr
    };
    return json.encode(resultMap);
  }
  Future<void>extractData(String jsonData,{required Future<void> Function()listenerBeforeInsertion,
    required void Function(bool)listenerComplete})async{

    try{
      final Map<String,dynamic>data=json.decode(jsonData);

      final hadithListJsonArr=data["listHadith"] as List;
      final listsJsonArr=data["list"] as List;
      final savePointsJsonArr=data["savePoint"] as List;
      final topicSavePointsJsonArr=data["topicSavePoint"] as List;
      final verseListJsonArr=data["listVerse"] as List;
      final historiesJsonArr=data["history"] as List;
      final sharedJsonArr=data["sharedPreferences"] as List;

      final hadithLists=hadithListJsonArr.map((e) => ListHadithEntity.fromJson(e)).toList();
      final lists=listsJsonArr.map((e) => ListEntity.fromJson(e)).toList();
      final savePoints=savePointsJsonArr.map((e) => SavePoint.fromJson(e)).toList();
      final topicSavePoints=topicSavePointsJsonArr.map((e) => TopicSavePointEntity.fromJson(e)).toList();
      final verseLists=verseListJsonArr.map((e) => ListVerseEntity.fromJson(e)).toList();
      final histories=historiesJsonArr.map((e) => HistoryEntity.fromJson(e)).toList();

      await _reloadSharedPreferences(sharedJsonArr);

      await listenerBeforeInsertion.call();

      await backupDao.insertHistories(histories);
      await backupDao.insertSavePoints(savePoints);
      await backupDao.insertTopicSavePoints(topicSavePoints);

      await backupDao.insertLists(lists);
      await backupDao.insertHadithLists(hadithLists);
      await backupDao.insertVerseLists(verseLists);

      listenerComplete.call(true);
    }catch(e){
      listenerComplete.call(false);
    }
  }

  Future<void> _reloadSharedPreferences(List  sharedJsonArr)async{
    final SharedPreferences sharedPreferences=LocalStorage.sharedPreferences;

    for(var sh in sharedJsonArr){
      final map=json.decode(sh);
      final key=map["key"];
      final value=map["value"];
      final type=map["type"];
      if(value==null) {
        continue;
      }

      switch(type){
        case "int":
          await sharedPreferences.setInt(key, value);
          break;
        case "String":
          await sharedPreferences.setString(key, value);
          break;
        case "bool":
          await sharedPreferences.setBool(key, value);
          break;
        case "double":
          await sharedPreferences.setDouble(key, value);
          break;
        case "List<String>":
          await sharedPreferences.setStringList(key, value);
          break;
      }
    }
  }


  Future<void> extractDataFromUint8List(Uint8List data,
      {required Future<void> Function()listenerBeforeInsertion,
        required void Function(bool)listenerComplete})async{
    return await extractData(const Utf8Decoder().convert(data),
        listenerBeforeInsertion:listenerBeforeInsertion,listenerComplete:listenerComplete);
  }


  Future<Uint8List> getUint8ListData()async{
    return Uint8List.fromList(const Utf8Encoder().convert((await getJsonData())));
  }


}