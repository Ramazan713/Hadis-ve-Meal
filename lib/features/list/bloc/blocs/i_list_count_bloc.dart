

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/constants/enums/sourcetype_enum.dart';
import 'package:hadith/db/entities/list_entity.dart';
import 'package:hadith/db/entities/list_hadith_entity.dart';
import 'package:hadith/db/entities/list_verse_entity.dart';
import 'package:hadith/db/repos/list_repo.dart';
import 'package:hadith/utils/sourcetype_helper.dart';

import '../../../../db/repos/save_point_repo.dart';
import '../list_count_event.dart';
import 'dart:async';

import '../state/i_list_count_state.dart';


abstract class IListCountBloc<E extends IListCountEvent, S extends IListCountState> extends Bloc<E,S> {

  final ListRepo listRepo;
  final SavePointRepo savePointRepo;
  final S firstState;

  IListCountBloc({required this.listRepo,required this.savePointRepo,required this.firstState})  : super(firstState);

  Future<void> onListInserted(
      ListCountEventInserted event,
      Emitter<IListCountState> emit,
      ) async{

    final maxPosData=await listRepo.getMaxPosListWithSourceId(event.sourceId);
    final maxPos=maxPosData?.data;
    if(maxPos!=null){
      await listRepo.insertList(ListEntity(id: null, name: event.text,
          isRemovable: true, sourceId: event.sourceId,pos: maxPos+1));
    }
  }

  Future<void> onListDeleted(
      ListCountEventRemoved event,
      Emitter<IListCountState> emit,
      ) async{

    await listRepo.deleteList(event.listView.toListEntity());
    await savePointRepo.deleteSavePointWithQuery(OriginTag.list.savePointId, event.listView.id.toString());
  }

  Future<void> onDeleteItemsInList(ListCountEventRemoveItemsInList event,Emitter<IListCountState> emit)async{
    switch(event.sourceTypeEnum){
      case SourceTypeEnum.hadith:
        final listHadiths=await listRepo.getHadithListWithListId(event.listView.id);
        await listRepo.deleteHadithLists(listHadiths);
        break;
      case SourceTypeEnum.verse:
        final listVerses = await listRepo.getVerseListWithListId(event.listView.id);
        await listRepo.deleteVerseLists(listVerses);
        break;
    }
  }


  Future<void>onListRenamed(ListCountEventRenamed event,Emitter<IListCountState> emit) async{
    await listRepo.updateList(event.listView.toListEntity(name: event.newText));
  }

  void onArchiveList(ListCountEventArchive event,Emitter<IListCountState> emit)async{

    final maxPosData=await listRepo.getMaxPosList();
    final maxPos=maxPosData?.data;
    if(maxPos!=null){
      await listRepo.updateList(event.listView.toListEntity(isArchive: event.isArchive,listPos: maxPos+1));
    }
  }

  void onNewCopyList(ListCountEventNewCopy event,Emitter<IListCountState> emit)async{
    final list=event.listView;

    final maxPosData=await listRepo.getMaxPosListWithSourceId(list.sourceId);
    final maxPos=maxPosData?.data;
    if(maxPos!=null){

      final newListId=await listRepo.insertList(ListEntity(name: "${list.name} - Kopya", isRemovable: true,
          sourceId: list.sourceId,isArchive: list.isArchive,pos: maxPos+1));

      if(SourceTypeHelper.getSourceTypeWithSourceId(list.sourceId)==SourceTypeEnum.verse){
        final oldListVerses=await listRepo.getVerseListWithListId(list.id);
        final newListVerses=oldListVerses.map((e) =>
            ListVerseEntity(listId: newListId, verseId: e.verseId, pos: e.pos)).toList();
        await listRepo.insertVerseLists(newListVerses);
      }else{
        final oldListHadiths=await listRepo.getHadithListWithListId(list.id);
        final newListHadiths=oldListHadiths.map((e) =>
            ListHadithEntity(listId: newListId, hadithId: e.hadithId, pos: e.pos)).toList();
        await listRepo.insertHadithLists(newListHadiths);
      }

    }
  }

  @protected
  Future<void>onItemsListRequested(ListCountEventItemsRequested event,Emitter<IListCountState> emit);
}

