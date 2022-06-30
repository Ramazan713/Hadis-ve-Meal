import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/constants/enums/scope_filter_enum.dart';
import 'package:hadith/db/entities/savepoint.dart';

abstract class ISavePointEditEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class SavePointEditEventRequest extends ISavePointEditEvent{
  final OriginTag originTag;
  final String parentKey;
  final int bookIdBinary;
  final ScopeFilterEnum? scopeFilter;

  SavePointEditEventRequest({
    required this.originTag,
    required this.parentKey,required this.bookIdBinary,this.scopeFilter});

  @override
  List<Object?> get props => [originTag,parentKey,bookIdBinary,scopeFilter];
}

class SavePointEditEventRequestWithBook extends ISavePointEditEvent{
  final List<int>bookBinaryIds;
  final OriginTag? filter;
  SavePointEditEventRequestWithBook({
    required this.bookBinaryIds,this.filter});

  @override
  List<Object?> get props => [bookBinaryIds,filter];
}


class SavePointEditEventRename extends ISavePointEditEvent{
  final SavePoint savePoint;
  final String newTitle;
  SavePointEditEventRename({required this.savePoint,required this.newTitle});

  @override
  List<Object?> get props => [savePoint,newTitle];
}

class SavePointEditEventInsert extends ISavePointEditEvent{
  final int itemIndexPos;
  final OriginTag originTag;
  final int bookIdBinary;
  final String parentKey;
  final String parentName;
  final String title;
  final DateTime dateTime;

  SavePointEditEventInsert({required this.itemIndexPos,required this.originTag,
    required this.bookIdBinary,required this.parentKey,required this.parentName,
    required this.title,required this.dateTime});

  @override
  List<Object?> get props => [itemIndexPos,originTag,bookIdBinary,parentKey
    ,parentName];
}

class SavePointEditEventDelete extends ISavePointEditEvent{
  final SavePoint savePoint;
  SavePointEditEventDelete({required this.savePoint});

  @override
  List<Object?> get props => [savePoint];
}

class SavePointEditEventOverride extends ISavePointEditEvent{
  final SavePoint newSavePoint;
  SavePointEditEventOverride({required this.newSavePoint});
  @override
  List<Object?> get props => [newSavePoint];
}


