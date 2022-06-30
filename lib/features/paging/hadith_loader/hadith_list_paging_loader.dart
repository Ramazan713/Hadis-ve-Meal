

import 'package:flutter/material.dart';
import 'package:hadith/db/entities/helper/int_data.dart';

import 'package:hadith/db/entities/hadith.dart';
import 'package:hadith/features/paging/hadith_loader/i_paging_hadith_loader.dart';
import 'package:hadith/features/paging/mixin/list_mixin.dart';


class HadithListPagingLoader extends IPagingHadithLoader with ListMixinLoader{


  HadithListPagingLoader({required BuildContext context,required int listId})
      :super(context){
    this.listId=listId;
  }
  @override
  Future<List<Hadith>> getHadiths(int limit, int page) {
    return hadithRepo.getPagingListHadiths(limit, page,listId);
  }

  @override
  Future<IntData?> getPagingCount() {
    return hadithRepo.getListWithHadithCount(listId);
  }

}