import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/db/entities/verse_arabic.dart';
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
    final isFavorite = await listRepo.verseIsAddedToList(verse.id??0,false);
    return (isFavorite?.data!=0);
  }

  Future<List<VerseArabic>>_getArabicVerses(Verse verse)async{
    final verses=await verseRepo.getArabicVersesWithId(verse.id??0);
    return verses;
  }

  Future<bool>_isVerseAddListNotEmpty(Verse verse)async{
    final useArchiveListFeatures=_sharedPreferences.getBool(PrefConstants.useArchiveListFeatures.key)??false;
    final isAddedToList = useArchiveListFeatures ? await listRepo.verseIsAddedToList(verse.id??0, true):
        await listRepo.verseIsAddedToListWithArchive(verse.id??0, true, false);
    return (isAddedToList?.data!=0);
  }

  Future<bool>_isVerseArchiveAddListNotEmpty(Verse verse)async{
    final isAddedToList = await listRepo.verseIsAddedToListWithArchive(verse.id??0, true, true);
    return (isAddedToList?.data!=0);
  }



  Future<List<VerseModel>>_getVerseModels(int limit, int page)async{
    var verses=await getVerses(limit, page);
    var verseModels=<VerseModel>[];
    final baseRowNumber = (page-1)*limit;

    int i=0;
    for(var verse in verses){
      i++;
      final isFavorite=await _isVerseFavorite(verse);
      final isAddListNotEmpty=await _isVerseAddListNotEmpty(verse);
      final isArchiveAddListNotEmpty = await _isVerseArchiveAddListNotEmpty(verse);
      final arabicVerses = await _getArabicVerses(verse);
      verseModels.add(VerseModel(item: verse,arabicVerses: arabicVerses,
          rowNumber: baseRowNumber+i,isArchiveAddListNotEmpty:isArchiveAddListNotEmpty,
          isFavorite: isFavorite, isAddListNotEmpty: isAddListNotEmpty));
    }
    return Future.value(verseModels);
  }

}