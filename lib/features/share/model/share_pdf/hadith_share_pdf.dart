import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/db/entities/hadith.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';
import 'package:hadith/db/repos/hadith_repo.dart';
import 'package:hadith/features/share/model/share_pdf/i_share_pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

class HadithSharePdf extends ISharePdf<Hadith>{

  @override
  String getFileName(IListView listItem){
    return "hadith.${listItem.name}.pdf";
  }

  @override
  Future<List<Hadith>> getItems(BuildContext context, IListView listItem) {
    final hadithRepo=context.read<HadithRepo>();
    return hadithRepo.getListHadiths(listItem.id);
  }

  @override
  pw.Column getPdfContentWidget(Hadith item, Font font) {
    final style=pw.TextStyle(font: font,fontSize: fontSize);
    return pw.Column(
        children: [
          pw.Center(child:pw.Text(item.content.trim().replaceAll("\n", " ")
              ,style:style,textAlign: TextAlign.center)),
          pw.SizedBox(height: 7),
          pw.Center(child: pw.Text("- ${item.source}",style: style.copyWith(fontSize: fontSize-4,fontWeight: pw.FontWeight.bold),
              textAlign: TextAlign.center)),
          pw.SizedBox(height: 61)
        ]
    );
  }

  @override
  String getTypeName() {
    return "Hadisler";
  }

}