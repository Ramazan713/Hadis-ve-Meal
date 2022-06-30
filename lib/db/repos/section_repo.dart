

import 'package:hadith/db/entities/section.dart';
import 'package:hadith/db/services/section_dao.dart';
import 'package:hadith/db/entities/helper/item_count_model.dart';

class SectionRepo{
  final SectionDao sectionDao;

  SectionRepo({required this.sectionDao});

  Future<List<Section>> getSectionsWithBookId(int bookId)=>
      sectionDao.getSectionsWithBookId(bookId);

  Future<List<ItemCountModel>> getSectionCountWithBookId(int bookId)=>
      sectionDao.getSectionCountWithBookId(bookId);
}