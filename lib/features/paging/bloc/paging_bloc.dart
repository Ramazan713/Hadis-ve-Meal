import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_paging_status_enum.dart';
import 'package:hadith/constants/enums/font_size_enum.dart';
import 'package:hadith/features/paging/bloc/paging_event.dart';
import 'package:hadith/features/paging/bloc/paging_state.dart';
import 'package:hadith/constants/preference_constants.dart';
import 'package:hadith/utils/localstorage.dart';

import '../default_paging_loader.dart';
import '../i_paging_loader.dart';

class CustomPagingBloc extends Bloc<IPagingEvent,CustomPagingState>{
  
  late IPagingLoader _loader;
  
  CustomPagingBloc({IPagingLoader? loader})
      : super(const CustomPagingState(nextPage: 0,fontSize: 0,
      prevPage: 0,itemCount: 0,limit: 0,status: DataPagingStatus.initial,items: [])){
    _loader=loader??DefaultPagingLoader();
    on<PagingEventAddNext>(_onPagingAddNext,transformer: restartable());
    on<PagingEventAddPrev>(_onPagingAddPrev,transformer: restartable());
    on<PagingEventSetPage>(_onPagingSetPage,transformer: restartable());
    on<PagingEventRequestInit>(_onPagingSetCount,transformer: restartable());
    on<PagingEventSetFontSize>(_onPagingSetFontSize,transformer: restartable());
  }

  void setLoader(IPagingLoader loader,{List<IPagingEvent>? events}){
    _loader=loader;
    events?.forEach((element) {
      add(element);
    });
  }


  void _onPagingAddNext(PagingEventAddNext event,Emitter<CustomPagingState>emit) async{

    emit(state.copyWith(status: DataPagingStatus.nextLoading));
    var items=await _loader.getPagingItems(state.limit,state.nextPage);
    emit(state.copyWith(status: DataPagingStatus.success,
        nextPage: state.nextPage+1,
        isNext: items.isNotEmpty,
        items: [...state.items,...items]));
  }

  void _onPagingAddPrev(PagingEventAddPrev event,Emitter<CustomPagingState>emit) async{
    if(state.prevPage>0) {
      emit(state.copyWith(status: DataPagingStatus.prevLoading));
      var items = await _loader.getPagingItems(state.limit, state.prevPage);

      emit(state.copyWith(status: DataPagingStatus.pagingSuccess,
          prevPage: state.prevPage - 1,
          items: [...items, ...state.items]));
    }}
  void _onPagingSetPage(PagingEventSetPage event,Emitter<CustomPagingState>emit)async{
    emit(state.copyWith(status: DataPagingStatus.loading));

    List<dynamic>items=[];
    if(event.page>1) {
      items.addAll(await _loader.getPagingItems(event.limit,event.page-1));
    }
    items.addAll(await _loader.getPagingItems(event.limit,event.page));

    final int itemCount=event.reloadItemCount?(await _loader.getPagingCount())?.data??state.itemCount
        :state.itemCount;

    emit(state.copyWith(status: DataPagingStatus.setPagingSuccess,items: items,itemCount: itemCount,
        prevPage: event.page-2,nextPage: event.page+1,limit: event.limit,leftOver: event.leftOver,
        isNext: items.isNotEmpty));
  }

  void _onPagingSetCount(PagingEventRequestInit event,Emitter<CustomPagingState>emit)async{
    var itemCount=await _loader.getPagingCount();
    var sharedPreferences=LocalStorage.sharedPreferences;
    var fontSize=FontSize.values[sharedPreferences.getInt(PrefConstants.fontSize.key)??2];
    emit(state.copyWith(itemCount: itemCount?.data,fontSize: fontSize.size));
  }

  void _onPagingSetFontSize(PagingEventSetFontSize event,Emitter<CustomPagingState>emit)async{
    emit(state.copyWith(fontSize: event.fontSize));
  }
}