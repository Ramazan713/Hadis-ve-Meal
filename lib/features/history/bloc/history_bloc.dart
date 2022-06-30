import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/db/entities/history_entity.dart';
import 'package:hadith/db/repos/history_repo.dart';
import 'package:hadith/features/history/bloc/history_event.dart';
import 'package:hadith/features/history/bloc/history_state.dart';

class HistoryBloc extends Bloc<IHistoryEvent,HistoryState>{
  final HistoryRepo historyRepo;
  HistoryBloc({required this.historyRepo}) : super(const HistoryState.initial()){
    on<HistoryEventRequest>(_onHistoryRequest,transformer: restartable());
    on<HistoryEventRemoveItem>(_onHistoryDeleteItem);
    on<HistoryEventRemoveItems>(_onHistoryDeleteItems);
    on<HistoryEventInsert>(_onHistoryInsert);
  }

  void _onHistoryRequest(HistoryEventRequest event,Emitter<HistoryState>emit)async{
    emit(state.copyWith(status: DataStatus.loading));

    await emit.forEach<List<HistoryEntity>>(historyRepo.getStreamHistoryWithOrigin(event.originTag.savePointId)
        , onData: (data)=>state.copyWith(status: DataStatus.success,historyEntities: data));

  }

  void _onHistoryDeleteItem(HistoryEventRemoveItem event,Emitter<HistoryState>emit)async{
    await historyRepo.deleteHistory(event.historyEntity);
  }

  void _onHistoryDeleteItems(HistoryEventRemoveItems event,Emitter<HistoryState>emit)async{
    await historyRepo.deleteHistories(event.historyEntities);
  }

  void _onHistoryInsert(HistoryEventInsert event,Emitter<HistoryState>emit)async{
    final searchText=event.searchText.trim().toLowerCase();
    if(searchText!=""){
      final date=DateTime.now();
      final historyEntityExists=await historyRepo.getHistoryEntity(event.originTag.savePointId,
          searchText);
      if(historyEntityExists==null){
        final historyEntity=HistoryEntity(name: searchText, originType: event.originTag.savePointId,modifiedDate: date.toIso8601String());
        await historyRepo.insertHistory(historyEntity);
      }else{
        await historyRepo.updateHistory(historyEntityExists.copyWith(modifiedDate: date.toIso8601String()));
      }
    }

  }

}