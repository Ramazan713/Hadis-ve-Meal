
import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

abstract class IHadithVerse extends Equatable{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int bookId;

  const IHadithVerse({this.id,required this.bookId});

}