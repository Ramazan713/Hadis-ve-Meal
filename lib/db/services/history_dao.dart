

import 'package:floor/floor.dart';
import 'package:hadith/db/entities/history_entity.dart';

@dao
abstract class HistoryDao{

  @Query("select * from history where originType=:originId order by modifiedDate desc")
  Stream<List<HistoryEntity>>getStreamHistoryWithOrigin(int originId);

  @Query("""select * from history where originType=:originId and name=:name""")
  Future<HistoryEntity?>getHistoryEntity(int originId,String name);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int>insertHistory(HistoryEntity historyEntity);

  @delete
  Future<int>deleteHistory(HistoryEntity historyEntity);

  @delete
  Future<int>deleteHistories(List<HistoryEntity>historyEntities);

  @update
  Future<int>updateHistory(HistoryEntity historyEntity);


}