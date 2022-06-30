import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/features/bottom_nav/bloc/bottom_nav_event.dart';
import 'package:hadith/features/bottom_nav/bloc/bottom_nav_state.dart';



class BottomNavBloc extends Bloc<IBottomNavEvent,BottomNavState>{
  BottomNavBloc() : super(const BottomNavState(isCollapsed: true,withAnimation: true)){
    on<BottomNavChangeVisibility>(_onSetVisibility);
  }

  void _onSetVisibility(BottomNavChangeVisibility event,Emitter<BottomNavState>emit)async {
     emit(state.copyWith(isCollapsed:event.isCollapsed,withAnimation: event.withAnimation));
  }

}