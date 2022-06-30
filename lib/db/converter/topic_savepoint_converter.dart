

import 'package:floor/floor.dart';
import 'package:hadith/constants/enums/topic_savepoint_enum.dart';

class TopicSavePointConverter extends TypeConverter<TopicSavePointEnum,int>{
  @override
  TopicSavePointEnum decode(int databaseValue) {
    TopicSavePointEnum savePointEnum=TopicSavePointEnum.topic;
    for (var element in TopicSavePointEnum.values) {
      if(element.type==databaseValue) {
        savePointEnum=element;
      }
    }
    return savePointEnum;
  }

  @override
  int encode(TopicSavePointEnum value) {
    return value.type;
  }

}