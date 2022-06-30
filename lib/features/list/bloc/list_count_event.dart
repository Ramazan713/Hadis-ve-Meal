

import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/sourcetype_enum.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';

abstract class IListCountEvent extends Equatable {
  const IListCountEvent();

  @override
  List<Object> get props => [];
}

class ListCountEventInserted extends IListCountEvent {
  const ListCountEventInserted(this.text,this.sourceId);
  final String text;
  final int sourceId;

  @override
  List<Object> get props => [text,sourceId];
}

class ListCountEventRenamed extends IListCountEvent{
  final IListView listView;
  final String newText;
  const ListCountEventRenamed({required this.newText,required this.listView});
}

class ListCountEventRemoved extends IListCountEvent {
  const ListCountEventRemoved(this.listView);
  final IListView listView;

  @override
  List<Object> get props => [listView];
}
class ListCountEventArchive extends IListCountEvent{
  const ListCountEventArchive({required this.listView,required this.isArchive});
  final IListView listView;
  final bool isArchive;
  @override
  List<Object> get props => [listView,isArchive];
}

class ListCountEventNewCopy extends IListCountEvent{
  const ListCountEventNewCopy({required this.listView});
  final IListView listView;
  @override
  List<Object> get props => [listView];
}

class ListCountEventRemoveItemsInList extends IListCountEvent{
  final IListView listView;
  final SourceTypeEnum sourceTypeEnum;
  const ListCountEventRemoveItemsInList({required this.listView,required this.sourceTypeEnum});
  @override
  List<Object> get props => [listView,sourceTypeEnum];
}


class ListCountEventItemsRequested extends IListCountEvent{
  final String? searchCriteria;
  const ListCountEventItemsRequested({this.searchCriteria});
}


