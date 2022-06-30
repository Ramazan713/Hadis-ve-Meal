import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/book_enum.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/utils/search_criteria_helper.dart';
import 'package:hadith/db/repos/hadith_repo.dart';
import 'package:hadith/db/repos/verse_repo.dart';
import 'package:hadith/features/search/bloc/search_event.dart';
import 'package:hadith/features/search/bloc/search_state.dart';
import 'package:hadith/features/search/search_facade.dart';

class SearchBloc extends Bloc<ISearchEvent,SearchState>{
  final VerseRepo verseRepo;
  final HadithRepo hadithRepo;
  late final SearchFacade searchFacade;
  SearchBloc({required this.verseRepo,required this.hadithRepo})
      : super(const SearchState.initial()){

    searchFacade=SearchFacade(verseRepo: verseRepo, hadithRepo: hadithRepo);

    on<SearchEventRequestResult>(_onRequestResult);
    on<SearchEventResetState>(_onResetState);
  }

  void _onRequestResult(SearchEventRequestResult event, Emitter<SearchState> emit)async{
    emit(state.copyWith(status: DataStatus.loading));
    final String searchText=event.searchKey;
    final bool isRegEx= SearchCriteriaHelper.isRegEx();

    final int verseCount=((await searchFacade.getSearchWithVerseCount(searchText,isRegEx))?.data)??0;
    final int sitteCount=
        ((await searchFacade.getSearchHadithCountWithBook(searchText,BookEnum.sitte.bookId,isRegEx))?.data)??0;
    final int serlevhaCount=
        ((await searchFacade.getSearchHadithCountWithBook(searchText,BookEnum.serlevha.bookId,isRegEx))?.data)??0;
    final int hadithCount=sitteCount+serlevhaCount;
    emit(state.copyWith(status: DataStatus.success,hadithCount: hadithCount,serlevhaCount: serlevhaCount,
      sitteCount: sitteCount,verseCount: verseCount,searchKey: searchText));
  }

  void _onResetState(SearchEventResetState event, Emitter<SearchState> emit){
    emit(state.copyWith(status: DataStatus.success,verseCount: 0,sitteCount: 0,
      serlevhaCount: 0,hadithCount: 0,searchKey: ""));
  }
}