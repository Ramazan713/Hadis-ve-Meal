import 'package:equatable/equatable.dart';

class BottomNavState extends Equatable{
  final bool isCollapsed;
  final bool withAnimation;

  const BottomNavState({required this.isCollapsed,required this.withAnimation});

  BottomNavState copyWith({bool? isCollapsed,bool? withAnimation}){
    return BottomNavState(isCollapsed: isCollapsed??this.isCollapsed,
      withAnimation: withAnimation??this.withAnimation);
  }

  @override
  List<Object?> get props => [isCollapsed,withAnimation];

}