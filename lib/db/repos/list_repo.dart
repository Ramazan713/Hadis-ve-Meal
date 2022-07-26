
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/list_entity.dart';
import 'package:hadith/db/entities/list_hadith_entity.dart';
import 'package:hadith/db/entities/list_verse_entity.dart';
import 'package:hadith/db/entities/views/list_hadith_view.dart';
import 'package:hadith/db/entities/views/list_verse_view.dart';
import 'package:hadith/db/services/list_dao.dart';

class ListRepo{
  ListDao listDao;
  ListRepo({required this.listDao});

  Stream<List<ListEntity>>getStreamList(int sourceId) =>
      listDao.getStreamList(sourceId);

  Stream<List<ListEntity>>getStreamListWithArchive(int sourceId,bool isArchive)=>
      listDao.getStreamListWithArchive(sourceId, isArchive);


  Stream<List<ListEntity>>getStreamRemovableList(int sourceId)=>
      listDao.getStreamRemovableList(sourceId);

  Stream<List<ListEntity>>getStreamRemovableListWithArchive(int sourceId,bool isArchive)=>
      listDao.getStreamRemovableListWithArchive(sourceId, isArchive);


  Future<IntData?>getContentMaxPosFromListHadith(int listId)=>
      listDao.getContentMaxPosFromListHadith(listId);

  Future<IntData?>getContentMaxPosFromListVerse(int listId)=>
      listDao.getContentMaxPosFromListVerse(listId);


  Future<IntData?>getMaxPosListWithSourceId(int sourceId)=>
      listDao.getMaxPosListWithSourceId(sourceId);

  Future<IntData?>getMaxPosList()=>listDao.getMaxPosList();


  Future<List<ListHadithEntity>>getHadithListWithHadithId(int hadithId)=>
      listDao.getHadithListWithHadithId(hadithId);

  Future<List<ListHadithEntity>>getHadithListWithHadithIdArchive(int hadithId,bool isArchive)=>
      listDao.getHadithListWithHadithIdArchive(hadithId, isArchive);


  Future<List<ListHadithEntity>>getHadithListWithRemovable(int hadithId,bool isRemovable)=>
      listDao.getHadithListWithRemovable(hadithId, isRemovable);

  Future<List<ListHadithEntity>>getHadithListWithRemovableArchive(int hadithId,
      bool isRemovable,bool isArchive)=>
      listDao.getHadithListWithRemovableArchive(hadithId, isRemovable, isArchive);



  Future<List<ListVerseEntity>>getVerseListWithListId(int listId)=>
      listDao.getVerseListWithListId(listId);

  Future<List<ListVerseEntity>>getVerseListWithVerseId(int verseId)=>
      listDao.getVerseListWithVerseId(verseId);

  Future<List<ListVerseEntity>>getVerseListWithVerseIdArchive(int verseId,bool isArchive)=>
      listDao.getVerseListWithVerseIdArchive(verseId, isArchive);


  Future<List<ListVerseEntity>>getVerseListWithRemovable(int verseId,bool isRemovable)=>
      listDao.getVerseListWithRemovable(verseId, isRemovable);

  Future<List<ListVerseEntity>>getVerseListWithRemovableArchive(int verseId,
      bool isRemovable,bool isArchive)=>
      listDao.getVerseListWithRemovableArchive(verseId, isRemovable, isArchive);



  Stream<List<ListHadithView>> getListHadithViews(bool isArchive)=>
      listDao.getListHadithViews(isArchive);

  Stream<List<ListHadithView>> getSearchResultHadithViews(String name,bool isArchive)=>
      listDao.getSearchResultHadithViews("%$name%",name,"$name%","%$name",isArchive);

  Stream<List<ListHadithView>>getAllArchivedListViews()=>
      listDao.getAllArchivedListViews();

  Stream<List<ListVerseView>> getListVerseViews(bool isArchive)=>
      listDao.getListVerseViews(isArchive);

  Stream<List<ListVerseView>>getSearchResultVerseViews(String name,bool isArchive)=>
      listDao.getSearchResultVerseViews("%$name%",name,"$name%","%$name",isArchive);


  Future<List<ListHadithEntity>>getHadithListWithListId(int listId)=>
      listDao.getHadithListWithListId(listId);

  Future<int> insertList(ListEntity listEntity)=>listDao.insertList(listEntity);

  Future<int> updateList(ListEntity listEntity)=>listDao.updateList(listEntity);

  Future<int> deleteList(ListEntity listEntity)=>listDao.deleteList(listEntity);


  Future<int> insertHadithList(ListHadithEntity listHadithEntity)=>
      listDao.insertHadithList(listHadithEntity);

  Future<List<int>> insertHadithLists(List<ListHadithEntity> listHadithEntities)=>
      listDao.insertHadithLists(listHadithEntities);

  Future<int> updateHadithList(ListHadithEntity listHadithEntity)=>
      listDao.updateHadithList(listHadithEntity);

  Future<int> deleteHadithList(ListHadithEntity listHadithEntity)=>
      listDao.deleteHadithList(listHadithEntity);


  Future<int> insertVerseList(ListVerseEntity listVerseEntity)=>
      listDao.insertVerseList(listVerseEntity);

  Future<List<int>> insertVerseLists(List<ListVerseEntity> listVerseEntities)=>
      listDao.insertVerseLists(listVerseEntities);

  Future<int> updateVerseList(ListVerseEntity listVerseEntity)=>
      listDao.updateVerseList(listVerseEntity);

  Future<int> deleteVerseList(ListVerseEntity listVerseEntity)=>
      listDao.deleteVerseList(listVerseEntity);


  Future<void>deleteListHadithWithQuery(int listId)=>
      listDao.deleteListHadithWithQuery(listId);

  Future<void>deleteListVerseWithQuery(int listId)=>
      listDao.deleteListVerseWithQuery(listId);

  Future<int> deleteHadithLists(List<ListHadithEntity> listHadithEntities)=>
      listDao.deleteHadithLists(listHadithEntities);

  Future<int> deleteVerseLists(List<ListVerseEntity> listVerseEntities)=>
      listDao.deleteVerseLists(listVerseEntities);


  Future<IntData?>verseIsAddedToList(int verseId,bool isRemovable)=>
      listDao.verseIsAddedToList(verseId, isRemovable);

  Future<IntData?>verseIsAddedToListWithArchive(int verseId,bool isRemovable,bool isArchive)=>
      listDao.verseIsAddedToListWithArchive(verseId, isRemovable, isArchive);
}