
import 'package:floor/floor.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';

class OriginTagConverter extends TypeConverter<OriginTag,int>{
  @override
  OriginTag decode(int databaseValue) {
    OriginTag originTag=OriginTag.all;
    for (var element in OriginTag.values) {
      if(element.savePointId==databaseValue) {
        originTag=element;
      }
    }
    return originTag;
  }

  @override
  int encode(OriginTag value) {
    return value.savePointId;
  }
  
}