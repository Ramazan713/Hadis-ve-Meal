

import 'package:flutter/material.dart';

class LoadingUtil{
  static bool _isLoading=false;

  static void requestLoading(BuildContext context){
    if(!_isLoading){
      _isLoading=true;
      showModalBottomSheet(context: context,
          isScrollControlled: true,
          isDismissible: false,
          useRootNavigator: true,
          backgroundColor: Colors.transparent,
          enableDrag: false,
          builder: (context){
            return WillPopScope(
              onWillPop: (){
                return Future.value(false);
              },
              child: DraggableScrollableSheet(
                maxChildSize: 1,
                builder: (context,scrollController){
                  return Column(
                    children: const [
                      Center(child: CircularProgressIndicator(),)
                    ],
                  );
                },),
            );
          }).then((value){
        _isLoading=false;
      });
    }
  }

  static void requestCloseLoading(BuildContext context){
    if(_isLoading){
      Navigator.of(context,rootNavigator: true).pop();
    }
  }


}