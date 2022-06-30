import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:hadith/db/entities/hadith.dart';
import 'package:hadith/db/entities/topic.dart';


@Entity(tableName: "hadithTopic",foreignKeys: [
  ForeignKey(
      childColumns: ["topicId"],
      parentColumns: ["id"],
      entity: Topic
  ),
  ForeignKey(
      childColumns: ["hadithId"],
      parentColumns: ["id"],
      entity: Hadith
  )
],primaryKeys: ["hadithId","topicId"])
class HadithTopic{
  final int topicId;
  final int hadithId;

  HadithTopic({required this.topicId,required this.hadithId});

  String toJson(){
    return json.encode({"topicId":topicId,"hadithId":hadithId});
  }
  static HadithTopic fromJson(String data){
    final map=json.decode(data);
    return HadithTopic(topicId: map["topicId"], hadithId: map["hadithId"]);
  }


}