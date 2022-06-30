import 'package:floor/floor.dart';
import 'package:hadith/db/entities/list_entity.dart';

class IListView{
  @primaryKey
  final int id;
  final String name;
  final int itemCounts;
  final bool isRemovable;
  final int contentMaxPos;
  final bool isArchive;
  final int sourceId;
  final int listPos;

  IListView(
      {required this.id,
      required this.contentMaxPos,
      required this.name,
      required this.isArchive,
      required this.sourceId,
        required this.listPos,
      required this.itemCounts,
      required this.isRemovable});

  @override
  String toString() {
    return "IListView(id=$id,name=$name,count=$itemCounts)";
  }

  IListView copyWith(
      {int? id,
      String? name,
      int? itemCounts,
      int? contentMaxPos,
      bool? isArchive,
      int? sourceId,
        int? listPos,
        int? listMaxPos,
      bool? isRemovable}) {
    return IListView(
        id: id ?? this.id,
        name: name ?? this.name,
        contentMaxPos: contentMaxPos ?? this.contentMaxPos,
        isArchive: isArchive ?? this.isArchive,
        sourceId: sourceId ?? this.sourceId,
        listPos:listPos??this.listPos,
        itemCounts: itemCounts ?? this.itemCounts,
        isRemovable: isRemovable ?? this.isRemovable);
  }

  ListEntity toListEntity({int? id, String? name, bool? isRemovable,bool? isArchive,int? listPos}) {
    return ListEntity(
        pos: listPos??this.listPos,
        name: name ?? this.name,
        isRemovable: isRemovable ?? this.isRemovable,
        sourceId: sourceId,
        id: id ?? this.id,
        isArchive: isArchive??this.isArchive);
  }

}
