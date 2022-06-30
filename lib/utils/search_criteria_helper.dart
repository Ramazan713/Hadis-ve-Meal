

import 'package:hadith/constants/preference_constants.dart';
import 'package:hadith/utils/localstorage.dart';

import '../constants/enums/search_criteria_enum.dart';

class SearchCriteriaHelper{
  static SearchCriteriaEnum getCriteria(){
    final pos=LocalStorage.sharedPreferences.getInt(PrefConstants.searchCriteriaEnum.key)??PrefConstants.searchCriteriaEnum.defaultValue;
    return SearchCriteriaEnum.values[pos];
  }

  static bool isRegEx(){
    return getCriteria()==SearchCriteriaEnum.multipleKeys;
  }

  static bool isRegExWithCriteria(SearchCriteriaEnum criteriaEnum){
    return criteriaEnum == SearchCriteriaEnum.multipleKeys;
  }

}