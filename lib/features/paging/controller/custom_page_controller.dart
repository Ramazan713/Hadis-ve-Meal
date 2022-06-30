
import 'package:flutter/material.dart';
import 'package:hadith/features/paging/controller/custom_scrolling_controller.dart';

class CustomPageController extends CustomScrollingController{
  PageController? pageController;

  CustomPageController({this.pageController});

  void setPageController(PageController controller){
    pageController=controller;
  }
  Future<void>? previousPage ({Curve curve=Curves.easeIn,required Duration duration}){
    return pageController?.previousPage(duration: duration, curve: curve);
  }
  Future<void>? nextPage({Curve curve=Curves.easeIn, required Duration duration}){
    return pageController?.nextPage(duration: duration, curve: curve);
  }
  double? getPage()=>pageController?.page;
}