
import 'package:equatable/equatable.dart';

abstract class IBottomNavEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class BottomNavChangeVisibility extends IBottomNavEvent{
  final bool isCollapsed;
  final bool withAnimation;
  BottomNavChangeVisibility({required this.isCollapsed,this.withAnimation=true});
  @override
  List<Object?> get props => [isCollapsed,withAnimation];
}