import 'package:floor/floor.dart';
import 'package:hadith/db/entities/section.dart';
import 'package:hadith/db/entities/helper/item_count_model.dart';



@dao
abstract class SectionDao{

  @Query("select * from section where bookId=:bookId")
  Future<List<Section>> getSectionsWithBookId(int bookId);

  @Query("""select S.id,S.name,count(T.id)itemCount from
    section S, Topic T where S.id=T.sectionId and S.bookId=:bookId group by S.id""")
  Future<List<ItemCountModel>> getSectionCountWithBookId(int bookId);

}