import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/sourcetype_enum.dart';
import 'package:hadith/db/entities/helper/item_count_model.dart';
import 'package:hadith/db/repos/topic_repo.dart';
import 'package:hadith/features/topic/bloc/topic_event.dart';
import 'package:hadith/features/topic/bloc/topic_state.dart';

class TopicBloc extends Bloc<ITopicEvent,TopicState>{
  final TopicRepo topicRepo;

  TopicBloc({required this.topicRepo})
      : super(const TopicState.initial()){

    on<TopicEventRequest>(_onTopicRequested,transformer: restartable());
  }
  void _onTopicRequested(TopicEventRequest event,Emitter<TopicState>emit)async{
    emit(state.copyWith(status: DataStatus.loading));


    final Future<List<ItemCountModel>> hadithSource;
    final Future<List<ItemCountModel>> verseSource;

    final isSearching=event.searchCriteria!=null&&event.searchCriteria!="";

    if(event.sectionId==0){//All Topics
      hadithSource = isSearching?
        topicRepo.getSearchHadithTopicWithBookId(event.bookId, event.searchCriteria??""):
        topicRepo.getHadithTopicWithBookId(event.bookId);

      verseSource = isSearching?
        topicRepo.getSearchVerseTopicWithBookId(event.bookId, event.searchCriteria??""):
        topicRepo.getVerseTopicWithBookId(event.bookId);

    }else{//Topics with sectionId
      hadithSource = isSearching?
        topicRepo.getSearchHadithTopicWithSectionId(event.sectionId, event.searchCriteria??""):
        topicRepo.getHadithTopicWithSectionId(event.sectionId);

      verseSource = isSearching?
        topicRepo.getSearchVerseTopicWithSectionId(event.sectionId, event.searchCriteria??""):
        topicRepo.getVerseTopicWithSectionId(event.sectionId);
    }

    final sourceData=event.sourceTypeEnum==SourceTypeEnum.hadith?
      hadithSource:verseSource;

    final topics=await sourceData;

    emit(state.copyWith(status: DataStatus.success,topics: topics));
  }
}