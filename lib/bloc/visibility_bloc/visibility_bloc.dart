

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/bloc/visibility_bloc/visibility_event.dart';
import 'package:hadith/bloc/visibility_bloc/visibility_state.dart';

class VisibilityBloc extends Bloc<IVisibilityEvent,VisibilityState>{
  VisibilityBloc() : super(const VisibilityState(isVisible: true)){
    on<VisibilityEventSet>(_onSetVisibility,transformer: restartable());
  }

  void _onSetVisibility(VisibilityEventSet event,Emitter<VisibilityState>emit)async{
    emit(state.copyWith(isVisible: event.isVisible,option: event.option));
  }

}