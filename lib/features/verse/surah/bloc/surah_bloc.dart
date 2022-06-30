

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/repos/surah_repo.dart';
import 'package:hadith/features/verse/surah/bloc/surah_event.dart';
import 'package:hadith/features/verse/surah/bloc/surah_state.dart';

class SurahBloc extends Bloc<ISurahEvent,SurahState>{
  final SurahRepo surahRepo;
  SurahBloc({required this.surahRepo}) : super(const SurahState(items: [], status: DataStatus.initial)){
    on<SurahEventRequested>(_onDataRequested);
  }
  void _onDataRequested(SurahEventRequested event,Emitter<SurahState>emit)async{
    emit(state.copyWith(status: DataStatus.loading));
    final dataSource=event.searchCriteria!=null?surahRepo.getSearchedSurahs(event.searchCriteria??""):
        surahRepo.getAllSurah();
    final data=await dataSource;
    emit(state.copyWith(status: DataStatus.success,items: data));
  }
}