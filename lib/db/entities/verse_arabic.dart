

import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';
import 'package:hadith/db/entities/verse.dart';

@Entity(tableName: "verseArabic",foreignKeys: [
  ForeignKey(childColumns: ["mealId"], parentColumns: ["id"], entity: Verse)
])
class VerseArabic extends Equatable{
  @primaryKey
  final int mealId;
  final String verse;
  final String verseNumber;
  const VerseArabic({required this.mealId,required this.verse,required this.verseNumber});

  @override
  List<Object?> get props => [mealId,verse,verseNumber];
}