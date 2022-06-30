

enum FontSize{
  verySmall,small,medium,large,veryLarge
}

extension FontSizeExtension on FontSize{
  double get size{
    switch(this){
      case FontSize.verySmall:
        return 12;
      case FontSize.small:
        return 14;
      case FontSize.medium:
        return 18;
      case FontSize.large:
        return 22;
      case FontSize.veryLarge:
        return 27;
    }
  }

  String get shortName{
    switch(this){
      case FontSize.verySmall:
        return "Çok Küçük";
      case FontSize.small:
        return "Küçük";
      case FontSize.medium:
        return "Orta";
      case FontSize.large:
        return "Büyük";
      case FontSize.veryLarge:
        return "Çok Büyük";
    }
  }

}