

import 'package:hadith/features/paging/bloc/paging_bloc.dart';
import 'package:hadith/features/paging/bloc/paging_event.dart';

import '../i_paging_loader.dart';

class CustomScrollingController{
  CustomPagingBloc?bloc;
  int _prevLimit=0;
  int? _prevPage=0;
  int? _prevItemIndex=0;
  bool _prevAddedActive=false;

  void setBloc(CustomPagingBloc?bloc){
    this.bloc=bloc;
    if(_prevAddedActive){
      bloc?.add(PagingEventSetPage(limit: _prevLimit,page: _prevPage,itemIndex: _prevItemIndex));
      _prevAddedActive=false;
    }
  }

  void setLoader(IPagingLoader loader){
    bloc?.setLoader(loader);
  }


  void setPageEvent({int?page,int?itemIndex,required int limitNumber,bool reloadItemCount=false}){
    bloc?.add(PagingEventSetPage(limit: limitNumber,page: page,itemIndex: itemIndex,
      reloadItemCount: reloadItemCount));
  }
  void setPageEventWhenReady({int?page,int?itemIndex,required int limitNumber}){
    if(bloc!=null){
      bloc?.add(PagingEventSetPage(limit: limitNumber,page: page,itemIndex: itemIndex));
    }else{
      _prevLimit=limitNumber;
      _prevPage=page;
      _prevItemIndex=itemIndex;
      _prevAddedActive=true;
    }
  }
  void setFontSizeEvent(double fontSize){
    bloc?.add(PagingEventSetFontSize(fontSize: fontSize));
  }
}