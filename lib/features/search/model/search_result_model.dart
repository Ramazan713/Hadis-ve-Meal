import 'package:flutter/material.dart';
import 'package:hadith/features/paging/paging_argument.dart';

class SearchResultModel{
  final int resultCount;
  final String title;
  final PagingArgument argument;
  final String destinationId;
  SearchResultModel({required this.resultCount,required this.title,
    required this.argument,required this.destinationId});

  void navigate(BuildContext context){
    Navigator.pushNamed(context, destinationId,arguments: argument);
  }
}