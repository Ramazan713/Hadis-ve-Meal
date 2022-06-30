

enum SourceTypeEnum{
  hadith,verse
}

extension SourceTypeEnumExtension on SourceTypeEnum{
  int get sourceId{
    switch(this){
      case SourceTypeEnum.hadith:
        return 1;
      case SourceTypeEnum.verse:
        return 2;
    }
  }
  String get shortName{
    switch(this){
      case SourceTypeEnum.hadith:
        return "Hadis";
      case SourceTypeEnum.verse:
        return "Ayet";
    }
  }
}