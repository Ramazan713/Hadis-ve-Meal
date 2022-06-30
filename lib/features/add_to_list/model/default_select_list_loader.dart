

import 'package:hadith/db/entities/list_entity.dart';
import 'package:hadith/features/add_to_list/model/i_select_list_loader.dart';

class DefaultSelectListLoader extends ISelectListLoader{
  @override
  Future<int> deleteItemList(int listId) {
   return Future.value(0);
  }

  @override
  Stream<List<ListEntity>> getListItems() {
    return const Stream.empty();
  }

  @override
  Future<List> getSelectedListItems() {
    return Future.value([]);
  }

  @override
  Future<int> insertItemList(int listId) {
    return Future.value(0);
  }

  @override
  Future<void> formNewList(String label) {
    return Future.value();
  }

  @override
  Stream<List<ListEntity>> getStreamRemovableList() {
    return const Stream.empty();
  }

  @override
  Future<List> getSelectedListItemsWithRemovable(bool isRemovable) {
    return Future.value([]);
  }

}