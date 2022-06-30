import 'package:floor/floor.dart';

@Entity(tableName: "sourceType")
class SourceTypeEntity{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String sourceType;
  SourceTypeEntity({this.id,required this.sourceType});
}