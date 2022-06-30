import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:hadith/db/entities/topic.dart';
import 'package:hadith/db/entities/verse.dart';


@Entity(tableName: "verseTopic",foreignKeys: [
  ForeignKey(
      childColumns: ["verseId"],
      parentColumns: ["id"],
      entity: Verse
  ),
  ForeignKey(
      childColumns: ["topicId"],
      parentColumns: ["id"],
      entity: Topic
  )
],primaryKeys: ["verseId","topicId"])
class VerseTopic{
  final int verseId;
  final int topicId;

  VerseTopic({required this.verseId,required this.topicId});


  String toJson(){
    return json.encode({"topicId":topicId,"verseId":verseId});
  }
  static VerseTopic fromJson(String data){
    final map=json.decode(data);
    return VerseTopic(topicId: map["topicId"], verseId: map["verseId"]);
  }

}