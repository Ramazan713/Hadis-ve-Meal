

import 'package:equatable/equatable.dart';
import 'package:hadith/constants/app_constants.dart';


class IPagingEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class PagingEventAddNext extends IPagingEvent{}

class PagingEventAddPrev extends IPagingEvent{}

class PagingEventSetFontSize extends IPagingEvent{
  final double fontSize;
  PagingEventSetFontSize({required this.fontSize});
}

class PagingEventSetPage extends IPagingEvent{
  final int limit;
  late int page;
  late  int leftOver;
  final bool reloadItemCount;
  PagingEventSetPage({required this.limit,int? page,int? itemIndex,this.reloadItemCount=false}){
    this.page=page ?? (itemIndex!~/limit)+2;

    leftOver=itemIndex!=null?itemIndex%limit:0;
    if(itemIndex!=null){
      leftOver=itemIndex%limit;
      if(this.page!=2&&leftOver<kPagingPreviewSetIndexNumber){
          this.page=this.page-1;
          leftOver=limit+leftOver;
        }
    }else{
      leftOver = this.page==1?0:limit;
    }
  }
  @override
  List<Object?> get props => [limit,page,leftOver,reloadItemCount];
}

class PagingEventRequestInit extends IPagingEvent{}