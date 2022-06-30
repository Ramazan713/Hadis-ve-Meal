
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/db/entities/savepoint.dart';
import 'package:hadith/db/services/save_point_dao.dart';

class SavePointRepo{
  final SavePointDao savePointDao;
  SavePointRepo({required this.savePointDao});

  Future<int>insertSavePoint(SavePoint savePoint)=>savePointDao.insertSavePoint(savePoint);
  Future<int>deleteSavePoint(SavePoint savePoint)=>savePointDao.deleteSavePoint(savePoint);
  Future<int>updateSavePoint(SavePoint savePoint)=>savePointDao.updateSavePoint(savePoint);

  Future<SavePoint?> getAutoSavePoint(OriginTag originTag,String parentKey)=>
      savePointDao.getAutoSavePoint(originTag.savePointId, parentKey);

  Stream<List<SavePoint>>getStreamSavePoints(OriginTag originTag,String parentKey)=>
      savePointDao.getStreamSavePoints(originTag.savePointId, parentKey);

  Future<SavePoint?> getAutoSavePointWithBookIdBinary(int savePointType,int bookIdBinary)=>
      savePointDao.getAutoSavePointWithBookIdBinary(savePointType, bookIdBinary);

  Stream<List<SavePoint>>getStreamSavePointsWithBookIdBinary(int savePointType,int bookIdBinary)=>
      savePointDao.getStreamSavePointsWithBookIdBinary(savePointType, bookIdBinary);


  Stream<List<SavePoint>>getStreamSavePointsWithBook(List<int> bookBinaryIds)=>
      savePointDao.getStreamSavePointsWithBook(bookBinaryIds);

  Stream<List<SavePoint>>getStreamSavePointsWithBookFilter(List<int> bookBinaryIds,
      int savePointType)=>
      savePointDao.getStreamSavePointsWithBookFilter(bookBinaryIds, savePointType);


  Future<SavePoint?> getSavePointWithId(int id)=>savePointDao.getSavePointWithId(id);

  Future<SavePoint?> getSavePoint(int savePointType,String parentKey)=>
      savePointDao.getSavePoint(savePointType, parentKey);

  Future<void>deleteSavePointWithQuery(int savePointType,String parentKey)=>
      savePointDao.deleteSavePointWithQuery(savePointType, parentKey);

}