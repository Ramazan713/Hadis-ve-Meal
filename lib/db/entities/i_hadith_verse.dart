
import 'package:floor/floor.dart';

abstract class IHadithVerse{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int? rowNumber;
  final int bookId;

  IHadithVerse({this.id,this.rowNumber,required this.bookId});
}