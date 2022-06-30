

import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils{
  static void showLongToast(String msg){
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
    );
  }

}