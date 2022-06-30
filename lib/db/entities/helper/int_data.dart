

import 'package:floor/floor.dart';

@entity
class IntData{
  @primaryKey
  final int data;
  IntData({required this.data});

  @override
  String toString() {
    return "<IntData(data=$data)>";
  }
}