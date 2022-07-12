
import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

abstract class IHadithVerse extends Equatable{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int? rowNumber;
  final int bookId;

  const IHadithVerse({this.id,this.rowNumber,required this.bookId});

}