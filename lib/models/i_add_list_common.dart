
import 'package:hadith/db/entities/i_hadith_verse.dart';

abstract class IAddListCommon<T extends IHadithVerse>{
  late bool _isFavorite;
  late bool _isAddListNotEmpty;
  late bool _isArchiveAddedToList;
  final int rowNumber;
  final T item;

  IAddListCommon({required bool isFavorite,required this.item,required this.rowNumber,
    required bool isAddListNotEmpty,bool isArchiveAddedToList=false}){
    _isFavorite=isFavorite;
    _isAddListNotEmpty=isAddListNotEmpty;
    _isArchiveAddedToList=isArchiveAddedToList;
  }

  get isFavorite=>_isFavorite;
  set isFavorite(value){
    _isFavorite=value;
  }

  get isAddListNotEmpty=>_isAddListNotEmpty;
  set isAddListNotEmpty(value){
    _isAddListNotEmpty=value;
  }

  get isArchiveAddedToList=>_isArchiveAddedToList;
  set isArchiveAddedToList(value){
    _isArchiveAddedToList=value;
  }

}