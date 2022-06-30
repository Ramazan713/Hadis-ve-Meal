

import 'package:hadith/db/entities/list_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/preference_constants.dart';
import '../../../utils/localstorage.dart';

abstract class ISelectListLoader<T>{
  final SharedPreferences _sharedPreferences=LocalStorage.sharedPreferences;

  Stream<List<ListEntity>>getStreamRemovableList();
  Stream<List<ListEntity>>getListItems();
  Future<List<T>> getSelectedListItems();
  Future<List<T>> getSelectedListItemsWithRemovable(bool isRemovable);
  Future<int> insertItemList(int listId);
  Future<int> deleteItemList(int listId);
  Future<void> formNewList(String label);

  bool get useArchiveListFeatures=>
      _sharedPreferences.getBool(PrefConstants.useArchiveListFeatures.key)??
          PrefConstants.useArchiveListFeatures.defaultValue;

}