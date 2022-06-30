import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/models/i_add_list_common.dart';

class VerseModel extends IAddListCommon<Verse>{

  VerseModel({required Verse item,required bool isFavorite,
    required bool isAddListNotEmpty})
      :super(isFavorite: isFavorite,isAddListNotEmpty: isAddListNotEmpty,item: item);
}