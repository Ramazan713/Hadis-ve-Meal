

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/constants/extensions.dart';
import 'package:hadith/db/converter/origintag_converter.dart';
import 'package:hadith/db/entities/book.dart';
import 'package:hadith/db/entities/savepoint_type_entity.dart';

@Entity(tableName: "savePoint",foreignKeys: [
  ForeignKey(
      childColumns: ["savePointType"],
      parentColumns: ["id"],
      entity: SavePointTypeEntity),
  ForeignKey(
      childColumns: ["bookId"],
      parentColumns: ["id"],
      entity: Book)
])
class SavePoint extends Equatable{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int itemIndexPos;
  final String title;
  final bool isAuto;
  late final String modifiedDate;
  final OriginTag savePointType;

  final int bookIdBinary;
  final String parentName;

  //parentId show different meaning accordingly savePointType,
  //for all=>bookId, topic=>topicId, list=>listId,cuz=>CuzNo...
  final String parentKey;

  SavePoint({this.id,required this.itemIndexPos,required this.title,required this.isAuto,
    String? modifiedDate,required this.savePointType, required this.bookIdBinary,
    required this.parentKey,required this.parentName}){

    this.modifiedDate=modifiedDate??DateTime.now().toIso8601String();
  }

  SavePoint copyWith({int? id,int? itemIndexPos,String? title,bool? isAuto,String? modifiedDate,
    OriginTag? savePointType,int? bookIdBinary,String? parentKey,String? parentName}){
    return SavePoint(itemIndexPos: itemIndexPos??this.itemIndexPos,
        title: title??this.title,isAuto: isAuto??this.isAuto,
        savePointType: savePointType??this.savePointType,id: id??this.id,
        bookIdBinary: bookIdBinary??this.bookIdBinary, parentKey: parentKey??this.parentKey,
        parentName: parentName??this.parentName);
  }

  @override
  List<Object?> get props => [id,parentName,itemIndexPos,title,isAuto,modifiedDate,savePointType,bookIdBinary,parentKey];


  static String getAutoTitle(String parentName,String description,String modifiedDate,bool isAuto,
      bool wideSavePointScope,String originName){
    return "${isAuto?'Auto-':''}${wideSavePointScope?originName:parentName} - $description - ${DateTimeFormats.formatDate1(modifiedDate)}";
  }


  String toJson(){
    return json.encode({"id":id,"title":title,"isAuto":isAuto,"savePointType":OriginTagConverter().encode(savePointType),
        "bookIdBinary":bookIdBinary,"parentKey":parentKey,"parentName":parentName,
        "modifiedDate":modifiedDate,"itemIndexPos":itemIndexPos});
  }

  static SavePoint fromJson(String data){
    final map=json.decode(data);
    return SavePoint(id: map["id"], title: map["title"],isAuto:map["isAuto"],
        savePointType:OriginTagConverter().decode(map["savePointType"]),bookIdBinary: map["bookIdBinary"],parentKey: map["parentKey"],
        parentName: map["parentName"],modifiedDate: map["modifiedDate"],itemIndexPos: map["itemIndexPos"]);
  }


}