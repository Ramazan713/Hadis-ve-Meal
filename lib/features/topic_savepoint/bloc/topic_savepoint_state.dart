import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/topic_savepoint_entity.dart';

class TopicSavePointState extends Equatable{
  final DataStatus status;
  final TopicSavePointEntity? topicSavePointEntity;

  const TopicSavePointState({required this.status,required this.topicSavePointEntity});

  TopicSavePointState copyWith({DataStatus? status,required bool keepOldSavePoint,
    TopicSavePointEntity? topicSavePointEntity}){
    return TopicSavePointState(status: status??this.status,
        topicSavePointEntity: keepOldSavePoint?topicSavePointEntity??this.topicSavePointEntity:topicSavePointEntity);
  }

  @override
  List<Object?> get props => [status,topicSavePointEntity];

}