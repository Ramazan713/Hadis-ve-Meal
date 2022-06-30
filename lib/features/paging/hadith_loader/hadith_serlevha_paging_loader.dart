
import 'package:flutter/material.dart';
import 'package:hadith/constants/enums/book_enum.dart';
import 'package:hadith/db/entities/hadith.dart';
import 'package:hadith/db/entities/helper/int_data.dart';
import 'package:hadith/features/paging/hadith_loader/i_paging_hadith_loader.dart';

class HadithSerlevhaPagingLoader extends IPagingHadithLoader{

  final int _bookId=BookEnum.serlevha.bookId;

  HadithSerlevhaPagingLoader({required BuildContext context})
      : super(context);

  @override
  Future<IntData?> getPagingCount() {
    return hadithRepo.getHadithBookCount(_bookId);
  }

  @protected
  @override
  Future<List<Hadith>> getHadiths(int limit, int page) {
   return hadithRepo.getPagingBookHadiths(limit, page,_bookId);
  }
}