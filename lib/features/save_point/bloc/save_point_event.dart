import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';

abstract class ISavePointEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class SavePointEventAutoRequest extends ISavePointEvent{
  final OriginTag originTag;
  final int bookIdBinary;
  final String parentKey;

  SavePointEventAutoRequest({required this.originTag
    ,required this.bookIdBinary,
      required this.parentKey});
  @override
  List<Object?> get props => [originTag,bookIdBinary,parentKey];
}

class SavePointEventRequestWithId extends ISavePointEvent{
  final int? savePointId;
  SavePointEventRequestWithId({required this.savePointId});

  @override
  List<Object?> get props => [savePointId];
}

class SavePointEventRequestNearPoint extends ISavePointEvent{
  final int savePointType;
  final String parentKey;
  SavePointEventRequestNearPoint({required this.savePointType,required this.parentKey});
  @override
  List<Object?> get props => [savePointType,parentKey];
}

class SavePointEventAutoInsert extends ISavePointEvent{
  final int itemIndexPos;
  final OriginTag originTag;
  final int bookIdBinary;
  final String parentKey;
  final String parentName;


  SavePointEventAutoInsert({required this.itemIndexPos,required this.originTag,
    required this.bookIdBinary,
    required this.parentKey,required this.parentName});

  @override
  List<Object?> get props => [itemIndexPos,originTag,bookIdBinary,parentKey,parentName];
}


