

import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:hadith/constants/enums/topic_savepoint_enum.dart';
import 'package:hadith/db/converter/topic_savepoint_converter.dart';

@Entity(tableName: "topicSavePoint")
class TopicSavePointEntity{

  @primaryKey
  final int? id;
  final int pos;
  final TopicSavePointEnum type;
  final String parentKey;


  TopicSavePointEntity({this.id,required this.pos,required this.type,required this.parentKey});

  TopicSavePointEntity copyWith({int? id,required bool keepOldId,int? pos,TopicSavePointEnum? type,String? parentKey}){
    return TopicSavePointEntity(pos: pos??this.pos, type: type??this.type,
        parentKey: parentKey??this.parentKey,id: keepOldId?id??this.id:id);
  }

  String toJson(){
    return json.encode({"id":id,"type":TopicSavePointConverter().encode(type),"parentKey":parentKey,"pos":pos});
  }
  static TopicSavePointEntity fromJson(String data){
    final map=json.decode(data);
    return TopicSavePointEntity(id: map["id"], type:TopicSavePointConverter().decode(map["type"]),parentKey:map["parentKey"],
        pos:map["pos"]);
  }


}