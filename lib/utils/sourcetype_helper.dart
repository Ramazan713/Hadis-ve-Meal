
import '../constants/enums/book_enum.dart';
import '../constants/enums/sourcetype_enum.dart';

class SourceTypeHelper{

  static SourceTypeEnum getSourceTypeWithSourceId(int sourceId){
    if(sourceId==2){
      return SourceTypeEnum.verse;
    }
    return SourceTypeEnum.hadith;
  }


  static SourceTypeEnum getSourceTypeWithBookBinaryId(int binaryId){
    if(BookEnum.sitte.bookIdBinary==binaryId){
      return SourceTypeEnum.hadith;
    }else if(BookEnum.serlevha.bookIdBinary==binaryId){
      return SourceTypeEnum.hadith;
    }else if(BookEnum.serlevha.bookIdBinary|BookEnum.sitte.bookIdBinary==binaryId){
      return SourceTypeEnum.hadith;
    }else if(BookEnum.dinayetMeal.bookIdBinary==binaryId){
      return SourceTypeEnum.verse;
    }else{
      return SourceTypeEnum.hadith;
    }
  }
  static String getNameWithBookBinaryId(int binaryId){
    if(BookEnum.sitte.bookIdBinary==binaryId){
      return "Kütübi Sitte";
    }else if(BookEnum.serlevha.bookIdBinary==binaryId){
      return "Serlevha";
    }else if(BookEnum.serlevha.bookIdBinary|BookEnum.sitte.bookIdBinary==binaryId){
      return "Hadisler";
    }else if(BookEnum.dinayetMeal.bookIdBinary==binaryId){
      return "Kur'an";
    }else{
      return "";
    }
  }

}