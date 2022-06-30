
import 'package:floor/floor.dart';
import 'package:hadith/db/entities/book.dart';

@Entity(tableName: "section",foreignKeys: [
  ForeignKey(
      childColumns: ["bookId"],
      parentColumns: ["id"],
      entity: Book
  )
])
class Section{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final int bookId;

  Section({this.id,required this.name,required this.bookId});
}
