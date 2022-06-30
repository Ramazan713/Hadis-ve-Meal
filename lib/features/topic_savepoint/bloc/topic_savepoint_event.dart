import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/topic_savepoint_enum.dart';
import 'package:hadith/db/entities/topic_savepoint_entity.dart';

abstract class ITopicSavePointEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class TopicSavePointEventRequest extends ITopicSavePointEvent{
  final TopicSavePointEnum topicSavePointEnum;
  final String parentKey;
  TopicSavePointEventRequest({required this.topicSavePointEnum,required this.parentKey});
  @override
  List<Object?> get props => [topicSavePointEnum,parentKey];
}

class TopicSavePointEventInsert extends ITopicSavePointEvent{
  final TopicSavePointEnum topicSavePointEnum;

  final TopicSavePointEntity topicSavePointEntity;
  TopicSavePointEventInsert({required this.topicSavePointEntity,required this.topicSavePointEnum});
  @override
  List<Object?> get props => [topicSavePointEntity,topicSavePointEnum];
}

class TopicSavePointEventDelete extends ITopicSavePointEvent{
  final TopicSavePointEntity topicSavePointEntity;
  TopicSavePointEventDelete({required this.topicSavePointEntity});
  @override
  List<Object?> get props => [topicSavePointEntity];
}
