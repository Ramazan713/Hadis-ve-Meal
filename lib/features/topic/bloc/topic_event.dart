
import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/sourcetype_enum.dart';

abstract class ITopicEvent extends Equatable{
  @override
  List<Object?> get props =>[];

}

class SectionEventRequest extends ITopicEvent{
  final int bookId;
  final String? searchCriteria;
  SectionEventRequest({required this.bookId,this.searchCriteria});
  @override
  List<Object?> get props => [bookId];
}

class TopicEventRequest extends ITopicEvent{
  final int sectionId;
  final SourceTypeEnum sourceTypeEnum;
  final String? searchCriteria;
  final int bookId;

  TopicEventRequest({required this.sectionId,required this.bookId,required this.sourceTypeEnum,this.searchCriteria});
}