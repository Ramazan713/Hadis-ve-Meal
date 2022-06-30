import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/db/repos/list_repo.dart';
import 'package:hadith/db/repos/verse_repo.dart';
import 'package:hadith/features/verse/model/verse_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/preference_constants.dart';
import '../../../utils/localstorage.dart';
import '../i_paging_loader.dart';

abstract class IPagingVerseLoader extends IPagingLoader<VerseModel>{
  late final VerseRepo verseRepo;
  late final ListRepo listRepo;

  final SharedPreferences _sharedPreferences=LocalStorage.sharedPreferences;


  IPagingVerseLoader(BuildContext context){
    verseRepo=context.read<VerseRepo>();
    listRepo=context.read<ListRepo>();
  }

  @override
  @nonVirtual
  Future<List<VerseModel>> getPagingItems(int limit, int page) {
    return _getVerseModels(limit, page);
  }

  @override
  Future<IntData?> getPagingCount();

  @protected
  Future<List<Verse>>getVerses(int limit, int page);

  Future<bool>_isVerseFavorite(Verse verse)async{
    final listItems = await listRepo.getVerseListWithRemovable(verse.id??0,false);
    return listItems.isNotEmpty;
  }

  Future<bool>_isVerseAddListNotEmpty(Verse verse)async{
    final useArchiveListFeatures=_sharedPreferences.getBool(PrefConstants.useArchiveListFeatures.key)??false;

    final listItems=useArchiveListFeatures?await listRepo.getVerseListWithRemovable(verse.id??0, false):
    await listRepo.getVerseListWithRemovableArchive(verse.id??0, true, false);
    return listItems.isNotEmpty;
  }



  Future<List<VerseModel>>_getVerseModels(int limit, int page)async{
    var verses=await getVerses(limit, page);
    var verseModels=<VerseModel>[];
    for(var verse in verses){
      final isFavorite=await _isVerseFavorite(verse);
      final isAddListNotEmpty=await _isVerseAddListNotEmpty(verse);
      verseModels.add(VerseModel(item: verse,
          isFavorite: isFavorite, isAddListNotEmpty: isAddListNotEmpty));
    }
    return Future.value(verseModels);
  }

}