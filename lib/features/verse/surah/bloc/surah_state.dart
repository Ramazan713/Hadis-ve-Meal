

import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/surah.dart';

class SurahState extends Equatable{
  final List<Surah>items;
  final DataStatus status;

  const SurahState({required this.items,required this.status});

  SurahState copyWith({
    DataStatus? status,
    List<Surah>?items,
  }) {
    return SurahState(
      status: status ?? this.status,
      items:items??this.items,
    );
  }

  @override
  List<Object?> get props => [items,status];

}