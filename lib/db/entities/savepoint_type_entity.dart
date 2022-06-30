
import 'package:floor/floor.dart';

@Entity(tableName: "savePointType")
class SavePointTypeEntity{
  @PrimaryKey(autoGenerate: false)
  final int? id;
  final String name;
  SavePointTypeEntity({this.id,required this.name});
}