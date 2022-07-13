
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/preference_constants.dart';
import 'package:hadith/db/entities/hadith.dart';
import 'package:hadith/db/repos/hadith_repo.dart';
import 'package:hadith/db/repos/list_repo.dart';
import 'package:hadith/db/repos/topic_repo.dart';
import 'package:hadith/features/hadith/model/hadith_topics_model.dart';
import 'package:hadith/features/paging/i_paging_loader.dart';
import 'package:hadith/utils/localstorage.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../db/entities/helper/int_data.dart';

abstract class IPagingHadithLoader extends IPagingLoader<HadithTopicsModel>{
  late final TopicRepo topicRepo;
  late final HadithRepo hadithRepo;
  late final ListRepo listRepo;

  final SharedPreferences _sharedPreferences=LocalStorage.sharedPreferences;

  IPagingHadithLoader(BuildContext context){
    topicRepo=context.read<TopicRepo>();
    hadithRepo=context.read<HadithRepo>();
    listRepo=context.read<ListRepo>();
  }

  @override
  @nonVirtual
  Future<List<HadithTopicsModel>> getPagingItems(int limit, int page) {
    return _getHadithTopics(limit, page);
  }
  
  @override
  Future<IntData?> getPagingCount();

  @protected
  Future<List<Hadith>>getHadiths(int limit, int page);


  Future<bool>_isHadithFavorite(Hadith hadith)async{
    final listItems=await listRepo.getHadithListWithRemovable(hadith.id??0, false);
    return listItems.isNotEmpty;
  }

  Future<bool>_isHadithAddListNotEmpty(Hadith hadith)async{
    final useArchiveListFeatures=_sharedPreferences.getBool(PrefConstants.useArchiveListFeatures.key)??false;
    final listItems=useArchiveListFeatures?await listRepo.getHadithListWithRemovable(hadith.id??0, true):
        await listRepo.getHadithListWithRemovableArchive(hadith.id??0, true, false);
    return listItems.isNotEmpty;
  }

  Future<List<HadithTopicsModel>>_getHadithTopics(int limit, int page)async{
    var hadiths=await getHadiths(limit, page);
    var hadithTopics=<HadithTopicsModel>[];
    final baseRowNumber = (page-1)*limit;

    int i=0;
    for(var hadith in hadiths){
      i++;
      var topics=await topicRepo.getHadithTopics(hadith.id??0);
      final isFavorite=await _isHadithFavorite(hadith);
      final isHadithAddListNotEmpty=await _isHadithAddListNotEmpty(hadith);
      hadithTopics.add(HadithTopicsModel(item: hadith, topics: topics,
          rowNumber: baseRowNumber+i,
          isFavorite: isFavorite,isAddListNotEmpty: isHadithAddListNotEmpty));
    }
    return Future.value(hadithTopics);
  }

}