


enum ScopeFilterEnum{
  scope,restrict
}

extension ScopeFilterExtension on ScopeFilterEnum{
  String getDescription(){
    switch(this){
      case ScopeFilterEnum.scope:
        return "Hepsi";
      case ScopeFilterEnum.restrict:
        return "Geçerli Alan";
    }
  }
}