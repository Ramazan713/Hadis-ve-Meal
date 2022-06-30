
import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/helper/item_count_model.dart';

class TopicState extends Equatable{
  final DataStatus status;
  final List<ItemCountModel>topics;

  const TopicState({required this.status,required this.topics});

  const TopicState.initial({this.status=DataStatus.initial,this.topics=const []});

  TopicState copyWith({DataStatus? status,List<ItemCountModel>?topics}){
    return TopicState(status: status??this.status, topics: topics??this.topics);
  }

  @override
  List<Object?> get props => [status,topics];

}