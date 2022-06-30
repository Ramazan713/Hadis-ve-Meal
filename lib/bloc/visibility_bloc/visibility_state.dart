

import 'package:equatable/equatable.dart';

class VisibilityState extends Equatable{
  final bool isVisible;
  final int? option;
  const VisibilityState({required this.isVisible,this.option});

  VisibilityState copyWith({bool? isVisible,int? option}){
    return VisibilityState(isVisible: isVisible??this.isVisible,option: option);
  }

  @override
  List<Object?> get props => [isVisible,option];
}