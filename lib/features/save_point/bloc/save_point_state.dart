import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/savepoint.dart';

class SavePointState extends Equatable{
  final DataStatus status;
  final SavePoint? savePoint;

  const SavePointState({required this.status,required this.savePoint});

  SavePointState copyWith({
    DataStatus? status,
    SavePoint?savePoint,
    required bool keepOldSavePoint
  }) {
    return SavePointState(
      status: status ?? this.status,
      savePoint:keepOldSavePoint?savePoint??this.savePoint:savePoint,
    );
  }

  @override
  List<Object?> get props => [status,savePoint];

}