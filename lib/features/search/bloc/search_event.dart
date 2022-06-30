
import 'package:equatable/equatable.dart';

abstract class ISearchEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class SearchEventRequestResult extends ISearchEvent{
  final String searchKey;
  SearchEventRequestResult({required this.searchKey});

  @override
  List<Object?> get props => [searchKey];
}

class SearchEventResetState extends ISearchEvent{}

