

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';
import 'package:hadith/db/repos/verse_repo.dart';
import 'package:hadith/features/share/model/share_pdf/i_share_pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';


class ShareVersePDF extends ISharePdf<Verse>{

  @override
  String getFileName(IListView listItem){
    return "verse.${listItem.name}.pdf";
  }

  @override
  Future<List<Verse>> getItems(BuildContext context, IListView listItem) {
    final verseRepo=context.read<VerseRepo>();
    return verseRepo.getListVerses(listItem.id);
  }

  @override
  pw.Column getPdfContentWidget(Verse item, Font font) {
    final style=pw.TextStyle(font: font,fontSize: fontSize);
    return pw.Column(
        children: [
          pw.Center(child:pw.Text(item.content
              ,style:style,textAlign: pw.TextAlign.center)),
          pw.SizedBox(height: 7),
          pw.Center(child: pw.Text("- ${item.surahId}/${item.surahName}   ${item.verseNumber}. Ayet",style: style.copyWith(fontSize: fontSize-4,fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.center)),
          pw.SizedBox(height: 61)
        ]
    );
  }

  @override
  String getTypeName() {
    return "Ayetler";
  }

}