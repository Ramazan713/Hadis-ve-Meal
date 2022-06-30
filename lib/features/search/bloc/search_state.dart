import 'package:equatable/equatable.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';

class SearchState extends Equatable{
  final DataStatus status;
  final int verseCount;
  final int sitteCount;
  final int serlevhaCount;
  final int hadithCount;
  final String searchKey;

  const SearchState({required this.status,required this.verseCount,
    required this.sitteCount,required this.serlevhaCount,required this.hadithCount,
    required this.searchKey});

  const SearchState.initial({this.status=DataStatus.initial, this.verseCount=0,
    this.sitteCount=0, this.serlevhaCount=0, this.hadithCount=0,this.searchKey=""});

  SearchState copyWith({DataStatus? status,int?verseCount,int?sitteCount,int?serlevhaCount
    ,int?hadithCount,String? searchKey}){
    return SearchState(status: status??this.status, verseCount: verseCount??this.verseCount,
        sitteCount:sitteCount??this.sitteCount,hadithCount:hadithCount??this.hadithCount,
        serlevhaCount: serlevhaCount??this.serlevhaCount,searchKey:searchKey??this.searchKey);
  }

  @override
  List<Object?> get props => [status,verseCount,sitteCount,serlevhaCount,hadithCount,searchKey];
}