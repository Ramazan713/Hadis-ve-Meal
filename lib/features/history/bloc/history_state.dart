import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/history_entity.dart';

class HistoryState extends Equatable{
  final DataStatus status;
  final List<HistoryEntity>historyEntities;
  const HistoryState({required this.status,required this.historyEntities});

  HistoryState copyWith({DataStatus? status,List<HistoryEntity>?historyEntities}){
    return HistoryState(status: status??this.status,
        historyEntities: historyEntities??this.historyEntities);
  }

  const HistoryState.initial({ this.status=DataStatus.initial, this.historyEntities=const []});

  @override
  List<Object?> get props => [status,historyEntities];
}