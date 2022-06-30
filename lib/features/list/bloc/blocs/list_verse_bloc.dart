import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/repos/list_repo.dart';
import 'package:hadith/db/repos/save_point_repo.dart';
import 'package:hadith/features/list/bloc/list_count_event.dart';
import 'package:hadith/features/list/bloc/state/i_list_count_state.dart';

import '../../../../db/entities/views/list_verse_view.dart';
import '../state/list_verse_state.dart';
import 'i_list_count_bloc.dart';



class ListVerseBloc extends IListCountBloc<IListCountEvent, ListVerseState>{
  final isArchive=false;

  ListVerseBloc({required ListRepo listRepo,required SavePointRepo savePointRepo})
      : super(listRepo: listRepo,savePointRepo: savePointRepo,firstState: const ListVerseState()){
    on<ListCountEventInserted>(onListInserted);
    on<ListCountEventRemoved>(onListDeleted);
    on<ListCountEventRenamed>(onListRenamed);
    on<ListCountEventArchive>(onArchiveList);
    on<ListCountEventNewCopy>(onNewCopyList);
    on<ListCountEventItemsRequested>(onItemsListRequested,transformer: restartable());
    on<ListCountEventRemoveItemsInList>(onDeleteItemsInList,transformer: restartable());
  }
  @override
  Future<void> onItemsListRequested(ListCountEventItemsRequested event, Emitter<IListCountState> emit) async{
    emit(state.copyWith(status: DataStatus.loading));
    final isSearching=event.searchCriteria!=null&&event.searchCriteria!="";

    final streamData= isSearching?listRepo.getSearchResultVerseViews(event.searchCriteria!,isArchive):
    listRepo.getListVerseViews(isArchive);

    await emit.forEach<List<ListVerseView>>(streamData,
        onData: (data)=>state.copyWith(listItems: data,status: DataStatus.success));
  }
}

