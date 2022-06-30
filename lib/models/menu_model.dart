import 'package:flutter/material.dart';

class MenuModel<E>{
  final IconData? iconData;
  final String label;
  final E value;
  MenuModel({required this.label,required this.value,this.iconData});
}