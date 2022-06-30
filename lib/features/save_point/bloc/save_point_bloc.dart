import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/constants/save_point_constant.dart';
import 'package:hadith/utils/sourcetype_helper.dart';
import 'package:hadith/db/entities/savepoint.dart';
import 'package:hadith/db/repos/save_point_repo.dart';
import 'package:hadith/features/save_point/bloc/save_point_event.dart';
import 'package:hadith/features/save_point/bloc/save_point_state.dart';

class SavePointBloc extends Bloc<ISavePointEvent,SavePointState>{
  final SavePointRepo savePointRepo;
  SavePointBloc({required this.savePointRepo})
      : super(const SavePointState(status: DataStatus.initial,savePoint: null)){
    on<SavePointEventRequestWithId>(_onSavePointRequestWithId,transformer: restartable());
    on<SavePointEventAutoInsert>(_onSavePointAutoInsert,transformer: restartable());
    on<SavePointEventAutoRequest>(_onSavePointEventAutoRequest,transformer: restartable());
    on<SavePointEventRequestNearPoint>(_onSavePointRequestNearPoint,transformer: restartable());
  }

  void _onSavePointEventAutoRequest(SavePointEventAutoRequest event,Emitter<SavePointState>emit)async{
    emit(state.copyWith(status: DataStatus.loading,keepOldSavePoint: true));
    final data=savePointRepo.getAutoSavePoint(event.originTag,event.parentKey);

    emit(state.copyWith(status: DataStatus.success,savePoint:await data,keepOldSavePoint: false));
  }

  void _onSavePointRequestWithId(SavePointEventRequestWithId event,Emitter<SavePointState>emit)async{
    final savePointId=event.savePointId;
    if(savePointId!=null){
      emit(state.copyWith(status: DataStatus.loading,keepOldSavePoint: true));
      final data=await savePointRepo.getSavePointWithId(savePointId);
      emit(state.copyWith(status: DataStatus.success,savePoint: data,keepOldSavePoint: false));
    }
  }

  void _onSavePointRequestNearPoint(SavePointEventRequestNearPoint event,Emitter<SavePointState>emit)async{
    emit(state.copyWith(status: DataStatus.loading,keepOldSavePoint: true));
    final data=await savePointRepo.getSavePoint(event.savePointType, event.parentKey);
    emit(state.copyWith(status: DataStatus.success,savePoint: data,keepOldSavePoint: false));
  }

  void _onSavePointAutoInsert(SavePointEventAutoInsert event,Emitter<SavePointState>emit)async{
    final date=DateTime.now();
    final SavePoint savePoint;

    final wideSavePointScope=kSavePointScopeOrigins.contains(event.originTag);

    final prevSavePointLoader=wideSavePointScope?
      savePointRepo.getAutoSavePointWithBookIdBinary(event.originTag.savePointId,event.bookIdBinary):
      savePointRepo.getAutoSavePoint(event.originTag,event.parentKey);

    final prevSavePoint=await prevSavePointLoader;
    if(prevSavePoint!=null){
      savePoint=prevSavePoint.copyWith(itemIndexPos: event.itemIndexPos,
          parentKey: event.parentKey,
          parentName: event.parentName,
          modifiedDate: date.toIso8601String());
    }else{
      final typeDescription=SourceTypeHelper.getNameWithBookBinaryId(event.bookIdBinary);

      final title=SavePoint.getAutoTitle(event.parentName,typeDescription,date.toString(),true,
          wideSavePointScope,event.originTag.shortName);
      savePoint=SavePoint(itemIndexPos: event.itemIndexPos,
          parentName: event.parentName,
          parentKey: event.parentKey,
          title: title, isAuto: true, savePointType: event.originTag,
          bookIdBinary: event.bookIdBinary,modifiedDate: date.toIso8601String());
    }
    await savePointRepo.insertSavePoint(savePoint);
  }
}
