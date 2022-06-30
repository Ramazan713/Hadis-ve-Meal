
import 'package:floor/floor.dart';
import 'package:hadith/db/entities/book.dart';
import 'package:hadith/db/entities/i_hadith_verse.dart';

@Entity(tableName: "hadith",foreignKeys: [
  ForeignKey(
      childColumns: ["bookId"],
      parentColumns: ["id"],
      entity: Book
  )
])
class Hadith extends IHadithVerse{
  final String content;
  final String source;
  final int contentSize;

  Hadith({required this.content,required this.contentSize,required this.source,int? id,int? rowNumber,
    required int bookId})
      :super(id: id,rowNumber: rowNumber,bookId: bookId);

  @override
  String toString() {
    return "Hadith(id=$id,content=$content,source=$source,rowNumber=$rowNumber,bookId=$bookId)";
  }
}