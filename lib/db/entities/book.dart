import 'package:floor/floor.dart';
import 'package:hadith/db/entities/source_type_entity.dart';

@Entity(tableName: "book",foreignKeys:[
  ForeignKey(
      childColumns: ["sourceId"],
      parentColumns: ["id"],
      entity: SourceTypeEntity
  )
])
class Book{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final int sourceId;

  Book({this.id,required this.name,required this.sourceId});
}