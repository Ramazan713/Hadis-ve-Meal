
import 'package:flutter/material.dart';
import 'package:hadith/db/entities/hadith.dart';
import 'package:hadith/features/paging/hadith_loader/i_paging_hadith_loader.dart';
import 'package:hadith/db/entities/helper/int_data.dart';

import '../../../constants/enums/book_enum.dart';

class HadithSittePagingLoader extends IPagingHadithLoader{
  final int _bookId=BookEnum.sitte.bookId;

  HadithSittePagingLoader({required BuildContext context})
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