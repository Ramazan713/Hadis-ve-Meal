import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/constants/enums/scope_filter_enum.dart';
import 'package:hadith/constants/save_point_constant.dart';
import 'package:hadith/db/entities/savepoint.dart';
import 'package:hadith/db/repos/save_point_repo.dart';
import 'package:hadith/features/save_point/bloc/save_point_edit_event.dart';
import 'package:hadith/features/save_point/bloc/save_point_edit_state.dart';

class SavePointEditBloc extends Bloc<ISavePointEditEvent,SavePointEditState>{
  final SavePointRepo savePointRepo;

  SavePointEditBloc({required this.savePointRepo})
      : super(const SavePointEditState(status: DataStatus.initial,savePoints: [])){

    on<SavePointEditEventRequest>(_onSavePointRequest,transformer: restartable());
    on<SavePointEditEventRequestWithBook>(_onSavePointRequestWithBook,transformer: restartable());
    on<SavePointEditEventInsert>(_onSavePointInsert,transformer: restartable());
    on<SavePointEditEventDelete>(_onSavePointDelete,transformer: restartable());
    on<SavePointEditEventRename>(_onSavePointRename,transformer: restartable());
    on<SavePointEditEventOverride>(_onSavePointOverride,transformer: restartable());
  }

  void _onSavePointRequest(SavePointEditEventRequest event,Emitter<SavePointEditState>emit)async{
    emit(state.copyWith(status: DataStatus.loading));
    Stream<List<SavePoint>> itemStream;
    final wideSavePointScope=kSavePointScopeOrigins.contains(event.originTag);

    if(wideSavePointScope){
      itemStream=savePointRepo.getStreamSavePointsWithBookIdBinary(event.originTag.savePointId,
          event.bookIdBinary);
    }else{
      itemStream=savePointRepo.getStreamSavePoints(event.originTag,event.parentKey);
    }
    if(event.scopeFilter==ScopeFilterEnum.restrict){
      itemStream=itemStream.map((eventMap) => eventMap.where((e) => e.parentKey==event.parentKey).toList());
    }
    await emit.forEach<List<SavePoint>>(itemStream, onData: (data)=>state.copyWith(status: DataStatus.success,savePoints: data));
  }

  void _onSavePointRequestWithBook(SavePointEditEventRequestWithBook event,Emitter<SavePointEditState>emit)async{
    emit(state.copyWith(status: DataStatus.loading));
    final Stream<List<SavePoint>> dataStream;
    final filter=event.filter;
    if(filter!=null){
      dataStream=savePointRepo.getStreamSavePointsWithBookFilter(event.bookBinaryIds,
          filter.savePointId);
    }else{
      dataStream=savePointRepo.getStreamSavePointsWithBook(event.bookBinaryIds);
    }
    await emit.forEach<List<SavePoint>>(dataStream, onData: (data)=>state.copyWith(status: DataStatus.success,savePoints: data));
  }

  void _onSavePointInsert(SavePointEditEventInsert event,Emitter<SavePointEditState>emit)async{

    final savePoint=SavePoint(itemIndexPos: event.itemIndexPos,
        parentKey: event.parentKey,
        parentName: event.parentName,
        title: event.title, isAuto: false, savePointType: event.originTag,
        bookIdBinary: event.bookIdBinary,modifiedDate: event.dateTime.toIso8601String());
    await savePointRepo.insertSavePoint(savePoint);
  }

  void _onSavePointDelete(SavePointEditEventDelete event,Emitter<SavePointEditState>emit)async{
    await savePointRepo.deleteSavePoint(event.savePoint);
  }

  void _onSavePointRename(SavePointEditEventRename event,Emitter<SavePointEditState>emit)async{
    final savePoint=event.savePoint.copyWith(title: event.newTitle);
    await savePointRepo.updateSavePoint(savePoint);
  }

  void _onSavePointOverride(SavePointEditEventOverride event,Emitter<SavePointEditState>emit)async{
    final newSavePoint=event.newSavePoint.copyWith(
        modifiedDate: DateTime.now().toIso8601String());
    await savePointRepo.updateSavePoint(newSavePoint);
  }

}

