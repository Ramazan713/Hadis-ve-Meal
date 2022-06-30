


enum SearchCriteriaEnum {
  multipleKeys,oneExpression
}

extension SearchCriteriaExtension  on SearchCriteriaEnum {

  String getDescription(){
    switch(this){
      case SearchCriteriaEnum.oneExpression:
        return "Tek bir ifade olarak ara";
      case SearchCriteriaEnum.multipleKeys:
        return "Anahtar kelimelerle ara";
    }
  }

}