import 'package:flutter/material.dart';
import 'package:hadith/constants/menu_resources.dart';
import 'package:hadith/models/menu_model.dart';

List<MenuModel<int>> getDisplayItemsMenu(){
  List<MenuModel<int>>items=[];
  var item1=MenuModel(label: "Yazı Boyutu", value: MenuResources.fontSize, iconData: Icons.font_download_rounded);
  var item2=MenuModel(label: "Kayıt Noktası", value: MenuResources.savePoint,iconData: Icons.save);
  items.add(item1);
  items.add(item2);
  return items;
}
