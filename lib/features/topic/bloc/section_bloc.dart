import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/helper/item_count_model.dart';
import 'package:hadith/db/repos/topic_repo.dart';
import 'package:hadith/features/topic/bloc/topic_event.dart';
import 'package:hadith/features/topic/bloc/topic_state.dart';

class SectionBloc extends Bloc<ITopicEvent,TopicState>{
  final TopicRepo topicRepo;

  SectionBloc({required this.topicRepo}) : super(const TopicState.initial()){
    on<SectionEventRequest>(_onSectionRequested);
  }
  void _onSectionRequested(SectionEventRequest event,Emitter<TopicState>emit)async{
    emit(state.copyWith(status: DataStatus.loading));

    final isSearching=event.searchCriteria!=null&&event.searchCriteria!="";

    final dataSource=isSearching?
      topicRepo.getSearchSectionWithBookId(event.bookId, event.searchCriteria??""):
        topicRepo.getSectionWithBookId(event.bookId);

    final sections=await dataSource;

    if(!isSearching){
      final int itemCount=((await topicRepo.getTopicCountsWithBookId(event.bookId))?.data)??0;
      final itemCountModel=ItemCountModel(id: 0, name: "Tüm Başlıklar", itemCount: itemCount);
      sections.insert(0, itemCountModel);
    }
    emit(state.copyWith(status: DataStatus.success,topics: sections));
  }

}