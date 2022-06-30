import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/savepoint.dart';

class SavePointEditState extends Equatable{
  final DataStatus status;
  final List<SavePoint>savePoints;

  const SavePointEditState({required this.status,required this.savePoints});

  SavePointEditState copyWith({
    DataStatus? status,
    List<SavePoint>?savePoints,
  }) {
    return SavePointEditState(
      status: status ?? this.status,
      savePoints:savePoints??this.savePoints,
    );
  }

  @override
  List<Object?> get props => [status,savePoints];

}