
import 'package:floor/floor.dart';
import 'package:hadith/db/entities/section.dart';

@Entity(tableName: "topic",foreignKeys: [
  ForeignKey(
      childColumns: ["sectionId"],
      parentColumns: ["id"],
      entity: Section
  )
])
class Topic{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final int sectionId;

  Topic({this.id,required this.name,required this.sectionId});
}
