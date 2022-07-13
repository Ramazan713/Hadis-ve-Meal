import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/db/entities/verse_arabic.dart';
import 'package:hadith/models/i_add_list_common.dart';

class VerseModel extends IAddListCommon<Verse>{

  final List<VerseArabic>arabicVerses;


  VerseModel({required Verse item,required bool isFavorite,required this.arabicVerses,
    required bool isAddListNotEmpty,required int rowNumber})
      :super(isFavorite: isFavorite,isAddListNotEmpty: isAddListNotEmpty,
      item: item,rowNumber: rowNumber);
}