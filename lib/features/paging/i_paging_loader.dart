import 'package:hadith/db/entities/helper/int_data.dart';

abstract class IPagingLoader<T>{
  Future<List<T>> getPagingItems(int limit,int page);
  Future<IntData?> getPagingCount();
}