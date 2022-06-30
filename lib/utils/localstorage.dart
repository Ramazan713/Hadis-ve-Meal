

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage{
  static late SharedPreferences _sharedPreferences;

  static Future initStorage()async{
    _sharedPreferences=await SharedPreferences.getInstance();
  }

  static get sharedPreferences => _sharedPreferences;

}