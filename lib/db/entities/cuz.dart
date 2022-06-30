import 'package:floor/floor.dart';

@entity
class Cuz{
  @PrimaryKey(autoGenerate: false)
  final int cuzNo;
  final String name;

  Cuz({required this.cuzNo,required this.name});
}