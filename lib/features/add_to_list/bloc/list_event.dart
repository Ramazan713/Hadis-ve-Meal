

import 'package:equatable/equatable.dart';

class IListEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class SelectListEventRequested extends IListEvent{
  final bool includeFavoriteList;
  SelectListEventRequested({required this.includeFavoriteList});
}

class ListEventAddToList extends IListEvent{
  final int listId;
  ListEventAddToList({required this.listId});
  @override
  List<Object?> get props => [listId];
}

class ListEventRemoveToList extends IListEvent{
  final int listId;
  ListEventRemoveToList({required this.listId});
  @override
  List<Object?> get props => [listId];
}

class ListEventFormNewList extends IListEvent{
  final String label;
  ListEventFormNewList({required this.label});
  @override
  List<Object?> get props => [label];
}