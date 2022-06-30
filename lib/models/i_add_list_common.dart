
import 'package:hadith/db/entities/i_hadith_verse.dart';

abstract class IAddListCommon<T extends IHadithVerse>{
  late bool _isFavorite;
  late bool _isAddListNotEmpty;
  final T item;

  IAddListCommon({required bool isFavorite,required this.item,
    required bool isAddListNotEmpty}){
    _isFavorite=isFavorite;
    _isAddListNotEmpty=isAddListNotEmpty;
  }

  get isFavorite=>_isFavorite;
  set isFavorite(value){
    _isFavorite=value;
  }

  get isAddListNotEmpty=>_isAddListNotEmpty;
  set isAddListNotEmpty(value){
    _isAddListNotEmpty=value;
  }
}