import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';

import 'i_list_count_state.dart';

class ListVerseState extends IListCountState{
  const ListVerseState({
    DataStatus status = DataStatus.initial,
    List<IListView> listItems=const []
  }):super(status: status,listItems: listItems);

  ListVerseState copyWith({DataStatus? status, List<IListView>? listItems}) {
    return ListVerseState(
      status: status ?? this.status,
      listItems:listItems??this.listItems,
    );
  }
}