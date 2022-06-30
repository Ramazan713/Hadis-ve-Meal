import 'package:hadith/features/paging/i_paging_loader.dart';
import '../../db/entities/helper/int_data.dart';

class DefaultPagingLoader<T> extends IPagingLoader<T>{
  @override
  Future<List<T>> getPagingItems(int limit,int page){
    return Future.value([]);
  }
  @override
  Future<IntData?> getPagingCount(){
    return Future.value(IntData(data: 0));
  }
}