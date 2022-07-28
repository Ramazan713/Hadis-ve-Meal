import 'package:flutter/material.dart';

class CustomSearchSliverAppBar {
  final void Function()? onClosed;
  final void Function()? onCleared;
  final void Function(String text)? onSubmitted;
  final void Function(String text)? onChanged;
  late final TextEditingController controller;
  final ValueNotifier<bool>rebuildNotifier;

  late final String hintText;
  final SliverAppBar Function(BuildContext context) defaultSliverAppbar;
  var _isSearchBar = false;

  String prevText="";

  get isSearchBar => _isSearchBar;
  set isSearchBar(val){
    closeSearchBar();
  }


  void closeSearchBar(){
    _isSearchBar=false;
    controller.clear();
    onClosed?.call();
    _rebuild();
  }

  void _rebuild(){
    rebuildNotifier.value=!rebuildNotifier.value;
  }

  CustomSearchSliverAppBar(
      {required this.defaultSliverAppbar,
        required this.rebuildNotifier,
      required this.controller,
      String? hintText,
      this.onCleared,
      this.onClosed,
      this.onSubmitted,
      this.onChanged}) {
    this.hintText = hintText ?? "Ara";
  }

  SliverAppBar _getSearchAppBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      pinned: true,
      actions: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: TextField(
                      onChanged: (text){
                        if(text!=prevText){
                          prevText=text;
                          onChanged?.call(text);
                        }
                      },
                      controller: controller,
                      autofocus: true,
                      onSubmitted: onSubmitted,
                      decoration: InputDecoration(
                          hintText: hintText,
                          icon: IconButton(
                              onPressed: () {
                               closeSearchBar();
                              },
                              icon: const Icon(Icons.arrow_back,)),

                      )
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    controller.clear();
                    onCleared?.call();
                  },
                  icon: const Icon(
                    Icons.clear,
                  ))
            ],
          ),
        )
      ],
    );
  }

  IconButton getIconButton() {
    return IconButton(
        onPressed: () {
          _isSearchBar = true;
          _rebuild();
        },
        icon: const Icon(Icons.search),tooltip: "Ara");
  }

  SliverAppBar build(BuildContext context) {
    return _isSearchBar
        ? _getSearchAppBar(context)
        : defaultSliverAppbar(context);
  }

  void dispose() {
    controller.dispose();
  }
}
