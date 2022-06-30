
enum TopicSavePointEnum{
  topic,surah,cuz
}

extension TopicSavePointExtension on TopicSavePointEnum{
  int get type{
    switch(this){
      case TopicSavePointEnum.cuz:
        return 1;
      case TopicSavePointEnum.topic:
        return 2;
      case TopicSavePointEnum.surah:
        return 3;
    }
  }

  String get defaultParentKey{
    switch(this){
      case TopicSavePointEnum.cuz:
        return "cuz";
      case TopicSavePointEnum.topic:
        return "topic";
      case TopicSavePointEnum.surah:
        return "surah";
    }
  }

}