import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/sourcetype_enum.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';
import 'package:hadith/utils/sourcetype_helper.dart';
import 'package:hadith/utils/toast_utils.dart';
import '../bloc/blocs/i_list_count_bloc.dart';
import '../bloc/blocs/list_hadith_bloc.dart';
import '../bloc/blocs/list_verse_bloc.dart';
import '../bloc/list_count_event.dart';
import '../list_funcs.dart';

class ListBlocContext {
  IListCountBloc? _bloc;
  SourceTypeEnum _sourceType=SourceTypeEnum.hadith;

  ListBlocContext();

  void setBlockState(int currentIndex, BuildContext context) {
    _setSourceType(currentIndex);
    _setBlocWithSourceType(context);
  }

  void requestLoadItems({String? searchCriteria}) {
    _bloc?.add(ListCountEventItemsRequested(searchCriteria: searchCriteria));
  }

  void insertListItem(String listName) {
    _bloc?.add(ListCountEventInserted(listName,_sourceType.sourceId));
    ToastUtils.showLongToast("Liste Oluşturuldu");
  }

  void sendToArchive(IListView item){
    _bloc?.add(ListCountEventArchive(listView: item,isArchive: true));
  }

  void copyNewList(IListView item){
    _bloc?.add(ListCountEventNewCopy(listView: item));
  }

  void removeItem(IListView item) {
    _bloc?.add(ListCountEventRemoved(item));
    ToastUtils.showLongToast("Silindi");
  }

  void removeItemsInList(IListView item,SourceTypeEnum sourceTypeEnum){
    _bloc?.add(ListCountEventRemoveItemsInList(listView: item, sourceTypeEnum: sourceTypeEnum));
    ToastUtils.showLongToast("Silindi");
  }

  void renameItem(String newName, IListView item) {
    _bloc?.add(ListCountEventRenamed(newText: newName,listView: item));
    ToastUtils.showLongToast("Yeniden İsimlendirildi");

  }

  void pushNamedNavigator(IListView item, BuildContext context) {
    navigateToFromList(_sourceType, item, context);
  }

  Icon getDefaultListIcon(BuildContext context) {
    return getListItemIcon(_sourceType, context);
  }

  SourceTypeEnum getSourceType() => _sourceType;

  void _setSourceType(int index){
    _sourceType=SourceTypeHelper.getSourceTypeWithSourceId(index+1);
  }
  void _setBlocWithSourceType(BuildContext context){
    switch(_sourceType){
      case SourceTypeEnum.hadith:
        _bloc=context.read<ListHadithBloc>();
        break;
      case SourceTypeEnum.verse:
        _bloc=context.read<ListVerseBloc>();
        break;
    }
  }
}
