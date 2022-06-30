import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';
import 'package:hadith/features/list/bloc/state/i_list_count_state.dart';

class ListArchiveState extends IListCountState{

  const ListArchiveState({DataStatus status = DataStatus.initial,
    List<IListView> listItems=const []}):
        super(status: status,listItems: listItems);

  ListArchiveState copyWith({DataStatus? status, List<IListView>? listItems}) {
    return ListArchiveState(
      status: status ?? this.status,
      listItems:listItems??this.listItems,
    );
  }
}