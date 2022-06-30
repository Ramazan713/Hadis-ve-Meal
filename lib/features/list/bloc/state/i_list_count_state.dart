import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';

abstract class IListCountState extends Equatable {
  const IListCountState({
    this.status = DataStatus.initial,
    this.listItems=const []
  });

  final DataStatus status;
  final List<IListView>listItems;

  @override
  List<Object?> get props => [status, listItems];
}