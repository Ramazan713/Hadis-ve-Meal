import 'package:floor/floor.dart';
import 'package:hadith/db/entities/book.dart';
import 'package:hadith/db/entities/cuz.dart';
import 'package:hadith/db/entities/i_hadith_verse.dart';
import 'package:hadith/db/entities/surah.dart';


@Entity(tableName: "verse",foreignKeys: [
  ForeignKey(
      childColumns: ["cuzNo"],
      parentColumns: ["cuzNo"],
      entity: Cuz
  ),
  ForeignKey(
      childColumns: ["surahId"],
      parentColumns: ["id"],
      entity: Surah
  ),
  ForeignKey(
      childColumns: ["bookId"],
      parentColumns: ["id"],
      entity: Book
  )
])
class Verse extends IHadithVerse{
  final int surahId;
  final int cuzNo;
  final int pageNo;
  final String verseNumber;
  final String content;
  final bool isProstrationVerse;

  final String? surahName;



  const Verse({required this.surahId,required this.cuzNo,required this.pageNo,
  required this.verseNumber,required this.content,
    required this.surahName,required this.isProstrationVerse,int? id,
    required int bookId}):super(id: id,bookId: bookId);

  @override

  List<Object?> get props => [surahId,cuzNo,pageNo,verseNumber,content
    ,surahName,isProstrationVerse,id,bookId];
}