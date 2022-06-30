


enum OriginTag{
  all,list,topic,surah,cuz,search
}

extension OriginTagExtension on OriginTag{
  int get savePointId{
    switch(this){
      case OriginTag.list:
        return 1;
      case OriginTag.topic:
        return 2;
      case OriginTag.all:
        return 3;
      case OriginTag.surah:
        return 4;
      case OriginTag.cuz:
        return 5;
      case OriginTag.search:
        return 6;
    }
  }

  String get shortName{
    switch(this){
      case OriginTag.list:
        return "Liste";
      case OriginTag.topic:
        return "Konu";
      case OriginTag.all:
        return "Hepsi";
      case OriginTag.surah:
        return "Sure";
      case OriginTag.cuz:
        return "Cüz";
      case OriginTag.search:
        return "Arama";
    }
  }

}