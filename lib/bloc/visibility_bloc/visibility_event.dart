

import 'package:equatable/equatable.dart';

abstract class IVisibilityEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class VisibilityEventSet extends IVisibilityEvent{
  final bool isVisible;
  final int? option;
  VisibilityEventSet({required this.isVisible,this.option});

  @override
  List<Object?> get props => [isVisible,option];
}
