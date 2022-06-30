
import 'package:floor/floor.dart';
import 'package:hadith/db/entities/savepoint.dart';

@dao
abstract class SavePointDao{

  @Query("""select * from `savepoint` where savePointType=:savePointType
   and parentKey=:parentKey and isAuto=1 order by modifiedDate desc limit 1""")
  Future<SavePoint?> getAutoSavePoint(int savePointType,String parentKey);

  @Query("""select * from `savepoint` where savePointType=:savePointType
   and parentKey=:parentKey and isAuto=0 order by modifiedDate desc limit 1""")
  Future<SavePoint?> getSavePoint(int savePointType,String parentKey);


  @Query("""select * from `savepoint` where id=:id""")
  Future<SavePoint?> getSavePointWithId(int id);

  @Query("""select * from `savepoint` where
   savePointType=:savePointType and parentKey=:parentKey
   order by modifiedDate desc""")
  Stream<List<SavePoint>>getStreamSavePoints(int savePointType,String parentKey);


  @Query("""select * from `savepoint` where
   savePointType=:savePointType and bookIdBinary=:bookIdBinary
   order by modifiedDate desc""")
  Stream<List<SavePoint>>getStreamSavePointsWithBookIdBinary(int savePointType,int bookIdBinary);

  @Query("""select * from `savepoint` where savePointType=:savePointType
   and bookIdBinary=:bookIdBinary and isAuto=1 order by modifiedDate desc limit 1""")
  Future<SavePoint?> getAutoSavePointWithBookIdBinary(int savePointType,int bookIdBinary);

  @Query("""select * from `savepoint` where bookIdBinary in(:bookBinaryIds)
   order by modifiedDate desc""")
  Stream<List<SavePoint>>getStreamSavePointsWithBook(List<int> bookBinaryIds);

  @Query("""select * from `savepoint` where bookIdBinary in(:bookBinaryIds) 
    and savePointType=:savePointType order by modifiedDate desc""")
  Stream<List<SavePoint>>getStreamSavePointsWithBookFilter(List<int> bookBinaryIds,
      int savePointType);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int>insertSavePoint(SavePoint savePoint);

  @delete
  Future<int>deleteSavePoint(SavePoint savePoint);

  @update
  Future<int>updateSavePoint(SavePoint savePoint);

  @Query("""delete from `savepoint` where savePointType=:savePointType and parentKey=:parentKey""")
  Future<void>deleteSavePointWithQuery(int savePointType,String parentKey);

}