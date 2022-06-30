import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/db/entities/history_entity.dart';

abstract class IHistoryEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class HistoryEventRequest extends IHistoryEvent{
  final OriginTag originTag;
  HistoryEventRequest({required this.originTag});
  @override
  List<Object?> get props => [originTag];
}

class HistoryEventInsert extends IHistoryEvent{
  final String searchText;
  final OriginTag originTag;
  HistoryEventInsert({required this.searchText,required this.originTag});
  @override
  List<Object?> get props => [searchText,originTag];
}

class HistoryEventRemoveItem extends IHistoryEvent{
  final HistoryEntity historyEntity;
  HistoryEventRemoveItem({required this.historyEntity});
  @override
  List<Object?> get props => [historyEntity];
}

class HistoryEventRemoveItems extends IHistoryEvent{
  final List<HistoryEntity> historyEntities;
  HistoryEventRemoveItems({required this.historyEntities});
  @override
  List<Object?> get props => [historyEntities];
}


