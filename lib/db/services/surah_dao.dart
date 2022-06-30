import 'package:floor/floor.dart';
import 'package:hadith/db/entities/surah.dart';


@dao
abstract class SurahDao{

  @Query("select * from surah")
  Future<List<Surah>> getAllSurah();

  @Query("""with SurahText as(select id || name as text,id from surah)
    select S.* from surah S,SurahText ST where ST.id=S.id and ST.text like :query 
    order by (case when ST.text=:or1 then 1 when ST.text like :or2 then 2 when ST.text like :or3
      then 3 else 4 end)""")
  Future<List<Surah>>getSearchedSurahs(String query,String or1,String or2,String or3);

}