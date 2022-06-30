import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/repos/cuz_repo.dart';

import 'cuz_event.dart';
import 'cuz_state.dart';

class CuzBloc extends Bloc<ICuzEvent,CuzState>{
  final CuzRepo cuzRepo;

  CuzBloc({required this.cuzRepo}) : super(const CuzState(items: [], status: DataStatus.initial)){
    on<CuzEventRequested>(_onRequestData);
  }

  void _onRequestData(CuzEventRequested event,Emitter<CuzState>emit)async{
    emit(state.copyWith(status: DataStatus.loading));
    var data=await cuzRepo.getAllCuz();
    emit(state.copyWith(status: DataStatus.success,items: data));
  }
}