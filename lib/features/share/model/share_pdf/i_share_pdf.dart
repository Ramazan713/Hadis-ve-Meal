import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';
import 'package:hadith/utils/share_utils.dart';
import 'package:hadith/utils/loading_util.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

abstract class ISharePdf<Y>{
  final double fontSize=14;

  @protected
  pw.Column getPdfContentWidget(Y item,Font font);

  @protected
  pw.Widget getPdfTitleWidget(Font font){
    final style=pw.TextStyle(font: font,fontSize: fontSize+14,fontWeight: pw.FontWeight.bold);
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Center(child: pw.Text("Hadis ve Ayet",style: style)),
          pw.Center(child:pw.Text(getTypeName(),style: style.copyWith(fontSize: fontSize+5))),
          pw.SizedBox(height: 33)
        ]
    );
  }

  Future<List<Y>> getItems(BuildContext context,IListView listItem);

  String getFileName(IListView listItem);

  String getTypeName();

  List<pw.Widget> getBodyWidget(List<Y> items,Font font){
    final List<pw.Widget>bodyItems=[];
    bodyItems.add(getPdfTitleWidget(font));
    for(var item in items){
      bodyItems.add(getPdfContentWidget(item, font));
    }
    return bodyItems;
  }


  Future<String> getSharedFileName(BuildContext context,IListView item)async{
    LoadingUtil.requestLoading(context);
    final items=await getItems(context, item);
    final font=await PdfGoogleFonts.nunitoExtraLight();
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(build: (pw.Context context){
      return getBodyWidget(items,font);
    }));

    final directoryPath=await ShareUtils.getShareDirectoryPath(isRemoveFiles: true);

    final fileName="$directoryPath/${getFileName(item)}";
    final file = File(fileName);
    await file.create(recursive: true);
    await file.writeAsBytes(await pdf.save());

    return fileName;
  }

}