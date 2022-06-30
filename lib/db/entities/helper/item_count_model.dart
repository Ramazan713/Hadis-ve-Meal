
import 'package:floor/floor.dart';

@entity
class ItemCountModel{
  @primaryKey
  final int id;
  final String name;
  final int itemCount;
  final int? rowNumber;

  ItemCountModel({required this.id,required this.name,required this.itemCount,this.rowNumber});

}