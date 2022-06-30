
enum BookEnum{
  serlevha,
  sitte,
  dinayetMeal,
  none
}

extension BookIdsExtension on BookEnum{
  int get bookIdBinary{
    switch(this){
      case BookEnum.none:
        return 0;
      case BookEnum.serlevha:
        return 1;
      case BookEnum.sitte:
        return 2;
      case BookEnum.dinayetMeal:
        return 4;
    }
  }

  int get bookId{
    switch(this){
      case BookEnum.none:
        return 0;
      case BookEnum.serlevha:
        return 1;
      case BookEnum.sitte:
        return 2;
      case BookEnum.dinayetMeal:
        return 3;
    }
  }

}
