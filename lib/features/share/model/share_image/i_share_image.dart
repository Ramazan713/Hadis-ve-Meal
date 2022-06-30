

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hadith/utils/toast_utils.dart';
import 'dart:ui' as ui;

import 'package:share_plus/share_plus.dart';

import '../../../../utils/share_utils.dart';

abstract class IShareImage<T>{
  final GlobalKey _globalKey = GlobalKey();
  final double fontSize=18;

  @protected
  String getImageName(T item);

  @protected
  Widget getPreviewWidgetKey(BuildContext context,T item,GlobalKey globalKey);

  Widget getPreviewWidget(BuildContext context,T item){
    return getPreviewWidgetKey(context, item, _globalKey);
  }

  Future<void> _capturePng(BuildContext context,T item) async {
    try {
      RenderRepaintBoundary? boundary = _globalKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      ui.Image? image = await boundary?.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image?.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData?.buffer.asUint8List();
      await _convertImageToFile(pngBytes!,context,item);
    } catch (e) {

      ToastUtils.showLongToast("Bilinmeyen Bir Hata Oluştu");
    }
  }

  Future<void> _convertImageToFile(Uint8List image,BuildContext context,T item) async {

    final directoryPath=await ShareUtils.getShareDirectoryPath(isRemoveFiles: true);

    final imageName="$directoryPath/${getImageName(item)}";
    final file = File(imageName);
    await file.create(recursive: true);
    await file.writeAsBytes(image);

    Share.shareFiles([imageName],
        mimeTypes: ["image/png"]);

  }

  void snapshot(BuildContext context,T item){
    _capturePng(context,item);
  }


}