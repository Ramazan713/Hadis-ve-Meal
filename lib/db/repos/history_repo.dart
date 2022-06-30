

import 'package:hadith/db/entities/history_entity.dart';
import 'package:hadith/db/services/history_dao.dart';

class HistoryRepo{
  final HistoryDao historyDao;

  HistoryRepo({required this.historyDao});

  Stream<List<HistoryEntity>>getStreamHistoryWithOrigin(int originId)=>
      historyDao.getStreamHistoryWithOrigin(originId);

  Future<HistoryEntity?>getHistoryEntity(int originId,String name)=>
      historyDao.getHistoryEntity(originId, name);

  Future<int>insertHistory(HistoryEntity historyEntity)=>
      historyDao.insertHistory(historyEntity);

  Future<int>deleteHistory(HistoryEntity historyEntity)=>
      historyDao.deleteHistory(historyEntity);

  Future<int>deleteHistories(List<HistoryEntity>historyEntities)=>
      historyDao.deleteHistories(historyEntities);

  Future<int>updateHistory(HistoryEntity historyEntity)=>
      historyDao.updateHistory(historyEntity);


}