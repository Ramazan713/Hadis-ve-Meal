import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:hadith/db/entities/hadith.dart';


@Entity(tableName: "listHadith",foreignKeys: [
  ForeignKey(
      childColumns: ["listId"],
      parentColumns: ["id"],
      entity: List
  ),
  ForeignKey(
      childColumns: ["hadithId"],
      parentColumns: ["id"],
      entity: Hadith
  )
],primaryKeys: ["listId","hadithId"])
class ListHadithEntity extends Equatable{
  final int listId;
  final int hadithId;
  final int pos;

  const ListHadithEntity({required this.listId,required this.hadithId,required this.pos});

  @override
  List<Object?> get props => [listId,hadithId];

  String toJson(){
    return json.encode({"listId":listId,"hadithId":hadithId,"pos":pos});
  }
  static ListHadithEntity fromJson(String data){
    final map=json.decode(data);
    return ListHadithEntity(listId: map["listId"], hadithId: map["hadithId"],pos:map["pos"]);
  }

}