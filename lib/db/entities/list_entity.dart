import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:hadith/db/entities/source_type_entity.dart';


@Entity(tableName: "list",foreignKeys: [
  ForeignKey(
      childColumns: ["sourceId"],
      parentColumns: ["id"],
      entity: SourceTypeEntity
  )
])
class ListEntity extends Equatable{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final bool isRemovable;
  final int sourceId;
  final bool isArchive;
  final int pos;

  const ListEntity({this.id,required this.name,this.isArchive=false,
    required this.isRemovable,required this.sourceId,required this.pos});

  @override

  List<Object?> get props => [id,name,isRemovable,sourceId,isArchive];


  String toJson(){
    return json.encode({"id":id,"name":name,"isRemovable":isRemovable,"sourceId":sourceId,"isArchive":isArchive,"pos":pos});
  }

  static ListEntity fromJson(String data){
    final map=json.decode(data);
    return ListEntity(id: map["id"], name: map["name"],isRemovable:map["isRemovable"],
        sourceId:map["sourceId"],isArchive:map["isArchive"],pos:map["pos"]);
  }

}