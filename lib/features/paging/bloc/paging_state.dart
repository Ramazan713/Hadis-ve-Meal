import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_paging_status_enum.dart';



class CustomPagingState extends Equatable{
  final DataPagingStatus status;
  final List items;
  final int prevPage;
  final int nextPage;
  final int limit;
  final int itemCount;
  final bool isNext;
  final int? leftOver;
  final double fontSize;

  const CustomPagingState({required this.status,required this.items,required this.limit,
    required this.prevPage,required this.itemCount,required this.nextPage,this.leftOver,
  required this.fontSize,this.isNext=true});

  CustomPagingState copyWith({DataPagingStatus? status,List?items,
    int? limit,int? prevPage,int?nextPage,double?fontSize,
    int?itemCount,int? leftOver,bool? isNext}){

    return CustomPagingState(status: status??this.status, items: items??this.items,
        limit: limit??this.limit,nextPage:nextPage??this.nextPage,leftOver: leftOver??this.leftOver,
        prevPage: prevPage??this.prevPage,itemCount: itemCount??this.itemCount,isNext: isNext??this.isNext,
        fontSize:fontSize??this.fontSize);
  }

  @override
  List<Object?> get props => [status,items,prevPage,itemCount,nextPage,fontSize,isNext];

}

