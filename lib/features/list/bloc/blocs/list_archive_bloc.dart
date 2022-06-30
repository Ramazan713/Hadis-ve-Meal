import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/views/list_hadith_view.dart';
import 'package:hadith/db/repos/list_repo.dart';
import 'package:hadith/db/repos/save_point_repo.dart';
import 'package:hadith/features/list/bloc/list_count_event.dart';
import 'package:hadith/features/list/bloc/state/i_list_count_state.dart';

import '../state/list_archive_state.dart';
import 'i_list_count_bloc.dart';

class ListArchiveBloc extends IListCountBloc<IListCountEvent, ListArchiveState>{
  final isArchive=true;
  ListArchiveBloc({required ListRepo listRepo,required SavePointRepo savePointRepo})
      : super(listRepo: listRepo,savePointRepo: savePointRepo, firstState: const ListArchiveState()){
    on<ListCountEventItemsRequested>(onItemsListRequested,transformer: restartable());
    on<ListCountEventRemoved>(onListDeleted);
    on<ListCountEventRenamed>(onListRenamed);
    on<ListCountEventArchive>(onArchiveList);
  }

  @override
  Future<void> onItemsListRequested(ListCountEventItemsRequested event, Emitter<IListCountState> emit)async {
    emit(state.copyWith(status: DataStatus.loading));

    final streamData=listRepo.getAllArchivedListViews();

    await emit.forEach<List<ListHadithView>>(streamData,
        onData: (data)=>state.copyWith(listItems: data,status: DataStatus.success));
  }

}