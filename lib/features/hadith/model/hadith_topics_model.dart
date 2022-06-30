import 'package:hadith/db/entities/hadith.dart';
import 'package:hadith/db/entities/topic.dart';
import 'package:hadith/models/i_add_list_common.dart';

class HadithTopicsModel extends IAddListCommon<Hadith>{
  final List<Topic>topics;

  HadithTopicsModel({required Hadith item,required this.topics,required bool isFavorite,
    required bool isAddListNotEmpty})
      :super(isFavorite: isFavorite,isAddListNotEmpty: isAddListNotEmpty,item: item);


}