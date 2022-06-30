import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/cuz.dart';

class CuzState extends Equatable{
  final List<Cuz>items;
  final DataStatus status;

  const CuzState({required this.items,required this.status});

  CuzState copyWith({
    DataStatus? status,
    List<Cuz>?items,
  }) {
    return CuzState(
      status: status ?? this.status,
      items:items??this.items,
    );
  }

  @override
  List<Object?> get props => [items,status];

}