
import 'package:floor/floor.dart';

@entity
class ItemCountModel{
  @primaryKey
  final int id;
  final String name;
  final int itemCount;

  @ignore
  int? rowNumber=0;

  ItemCountModel({required this.id,required this.name,required this.itemCount,this.rowNumber=0});



}
