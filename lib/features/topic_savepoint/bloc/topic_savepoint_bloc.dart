import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/topic_savepoint_entity.dart';
import 'package:hadith/db/repos/topic_savepoint_repo.dart';
import 'package:hadith/features/topic_savepoint/bloc/topic_savepoint_event.dart';
import 'package:hadith/features/topic_savepoint/bloc/topic_savepoint_state.dart';

class TopicSavePointBloc extends Bloc<ITopicSavePointEvent,TopicSavePointState>{
  final TopicSavePointRepo savePointRepo;


  TopicSavePointBloc({required this.savePointRepo})
      : super(const TopicSavePointState(status: DataStatus.initial, topicSavePointEntity: null)){
    on<TopicSavePointEventRequest>(_onRequestSavePoint,transformer: restartable());
    on<TopicSavePointEventInsert>(_onInsertSavePoint,transformer: restartable());
    on<TopicSavePointEventDelete>(_onDeleteSavePoint,transformer: restartable());
  }


  void _onRequestSavePoint(TopicSavePointEventRequest event,Emitter<TopicSavePointState>emit)async{
    emit(state.copyWith(keepOldSavePoint: true,status: DataStatus.loading));
    await emit.forEach<TopicSavePointEntity?>(savePointRepo.
      getStreamTopicSavePointEntity(event.topicSavePointEnum, event.parentKey)
        , onData: (data)=>state.copyWith(keepOldSavePoint: false,status: DataStatus.success,topicSavePointEntity: data));
  }

  void _onInsertSavePoint(TopicSavePointEventInsert event,Emitter<TopicSavePointState>emit)async{
    final oldValue=await savePointRepo.getTopicSavePointEntity(event.topicSavePointEnum,event.topicSavePointEntity.parentKey);
    if(oldValue!=null){
      await savePointRepo.updateTopicSavePoint(event.topicSavePointEntity.copyWith(keepOldId: false,id: oldValue.id));
    }else{
      await savePointRepo.insertTopicSavePoint(event.topicSavePointEntity);
    }
  }

  void _onDeleteSavePoint(TopicSavePointEventDelete event,Emitter<TopicSavePointState>emit)async{
    await savePointRepo.deleteTopicSavePoint(event.topicSavePointEntity);
  }

}