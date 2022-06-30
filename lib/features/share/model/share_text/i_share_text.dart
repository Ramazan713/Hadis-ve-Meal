import 'package:flutter/material.dart';

abstract class IShareText<T>{

  String getSharedText(T item);

  Future<String> getSharedTextWithList(BuildContext context,int listId);

}