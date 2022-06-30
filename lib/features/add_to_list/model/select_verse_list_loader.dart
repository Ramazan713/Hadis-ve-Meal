

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/sourcetype_enum.dart';
import 'package:hadith/db/entities/list_entity.dart';
import 'package:hadith/db/entities/list_verse_entity.dart';
import 'package:hadith/db/repos/list_repo.dart';
import 'package:hadith/features/add_to_list/model/i_select_list_loader.dart';

class SelectVerseListLoader extends ISelectListLoader{
  late final ListRepo listRepo;
  final int verseId;
  final int _sourceId=SourceTypeEnum.verse.sourceId;

  SelectVerseListLoader({required BuildContext context,required this.verseId}){
    listRepo=context.read<ListRepo>();
  }
  @override
  Future<int> deleteItemList(int listId){
    return listRepo.deleteVerseList(ListVerseEntity(listId: listId, verseId: verseId,pos: 0));
  }

  @override
  Stream<List<ListEntity>> getListItems() {
    return useArchiveListFeatures?listRepo.getStreamRemovableList(_sourceId):
        listRepo.getStreamRemovableListWithArchive(_sourceId,false);
  }

  @override
  Future<int> insertItemList(int listId) async{
    int maxPos=((await listRepo.getContentMaxPosFromListVerse(listId))?.data)??0;
    return listRepo.insertVerseList(ListVerseEntity(listId: listId, verseId: verseId,pos: maxPos+1));
  }

  @override
  Future<List> getSelectedListItems() {
    return useArchiveListFeatures?listRepo.getVerseListWithRemovable(verseId,true):
        listRepo.getVerseListWithRemovableArchive(verseId,true, false);
  }

  @override
  Future<void> formNewList(String label) async{
    final maxPosData=await listRepo.getMaxPosListWithSourceId(_sourceId);
    final maxPos=maxPosData?.data;
    if(maxPos!=null){
      await listRepo.insertList(ListEntity(name: label,
          isRemovable: true, sourceId: _sourceId,pos: maxPos+1));
    }
  }

  @override
  Stream<List<ListEntity>> getStreamRemovableList() {
    return useArchiveListFeatures? listRepo.getStreamRemovableList(_sourceId):
        listRepo.getStreamRemovableListWithArchive(_sourceId,false);
  }

  @override
  Future<List> getSelectedListItemsWithRemovable(bool isRemovable) {
    return useArchiveListFeatures? listRepo.getVerseListWithRemovable(verseId, isRemovable):
        listRepo.getVerseListWithRemovableArchive(verseId, isRemovable, false);
  }

}