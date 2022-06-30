

import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/list_entity.dart';


class ListState extends Equatable{
  final DataStatus status;
  final List<ListEntity>allList;
  final List<int>selectedListIds;

  const ListState({required this.status,required this.allList,required this.selectedListIds});

  ListState copyWith({DataStatus? status,List<ListEntity>?allList, List<int>?selectedListIds}){
    return ListState(status: status??this.status,
        allList: allList??this.allList,selectedListIds:selectedListIds??this.selectedListIds);
  }

  @override
  List<Object?> get props => [status,selectedListIds,allList];
}