

enum ArabicVerseUIEnum{
  both,onlyMeal,onlyArabic
}

extension ArabicVerseEnumExtension on ArabicVerseUIEnum{
  String get description{
    switch(this){
      case ArabicVerseUIEnum.onlyArabic:
        return "Sadece arapça göster";
      case ArabicVerseUIEnum.onlyMeal:
        return "Sadece meal göster";
      case ArabicVerseUIEnum.both:
        return "Arapça ve meal göster";
    }
  }
}