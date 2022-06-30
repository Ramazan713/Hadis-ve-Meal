import 'package:floor/floor.dart';

@entity
class Surah{
  @PrimaryKey(autoGenerate: false)
  final int id;
  final String name;

  Surah({required this.id,required this.name});
}