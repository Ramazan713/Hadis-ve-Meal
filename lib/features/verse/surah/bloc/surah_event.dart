

import 'package:equatable/equatable.dart';

abstract class ISurahEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class SurahEventRequested extends ISurahEvent{
  final String? searchCriteria;
  SurahEventRequested({this.searchCriteria});
  @override
  List<Object?> get props => [searchCriteria];
}