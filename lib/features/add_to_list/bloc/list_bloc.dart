

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/constant.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/features/add_to_list/bloc/list_event.dart';
import 'package:hadith/db/entities/list_entity.dart';
import 'package:hadith/features/add_to_list/model/default_select_list_loader.dart';
import 'package:hadith/features/add_to_list/model/i_select_list_loader.dart';

import 'list_state.dart';

class ListBloc extends Bloc<IListEvent,ListState>{
  late ISelectListLoader? listLoader;
  ListBloc({ISelectListLoader? listLoader})
      : super(const ListState(status: DataStatus.initial,allList: [],selectedListIds: [])){

    this.listLoader=listLoader??DefaultSelectListLoader();
    on<SelectListEventRequested>(_onListEventRequest,transformer: restartable());
    on<ListEventAddToList>(_onAddToList,transformer: restartable());
    on<ListEventRemoveToList>(_onRemoveToList,transformer: restartable());
    on<ListEventFormNewList>(_onFormNewList);
  }

  void setLoader(ISelectListLoader listLoader){
    this.listLoader=listLoader;
  }

  Future<void>_onListEventRequest(SelectListEventRequested event,Emitter<ListState>emit)async {
    if(listLoader!=null){
      emit(state.copyWith(status: DataStatus.loading));

      final allItems=event.includeFavoriteList?listLoader!.getListItems()
          :listLoader!.getStreamRemovableList();

      final selectedItems=event.includeFavoriteList?await listLoader!.getSelectedListItems():
      await listLoader!.getSelectedListItemsWithRemovable(true);
      final selectedListIds=List.of(selectedItems.map((e) => (cast<int>(e.listId)??0)));

      await emit.forEach<List<ListEntity>>(allItems, onData: (data)=>state.copyWith(
          status: DataStatus.success,selectedListIds: selectedListIds,allList: data));
    }
  }

  Future<void>_onAddToList(ListEventAddToList event,Emitter<ListState>emit)async{
    await listLoader?.insertItemList(event.listId);
  }
  Future<void>_onRemoveToList(ListEventRemoveToList event,Emitter<ListState>emit)async{
    await listLoader?.deleteItemList(event.listId);
  }

  Future<void> _onFormNewList(ListEventFormNewList event,Emitter<ListState>emit)async{
    await listLoader?.formNewList(event.label);
  }

}