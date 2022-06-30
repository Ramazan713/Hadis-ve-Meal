import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/db/repos/verse_repo.dart';
import 'package:hadith/features/share/model/share_text/i_share_text.dart';

class ShareVerseText extends IShareText<Verse>{
  @override
  String getSharedText(Verse item) {
    return "${item.surahId}/${item.surahName}\n${item.verseNumber} - ${item.content}\n";
  }

  @override
  Future<String> getSharedTextWithList(BuildContext context, int listId) async{
    final verseRepo=context.read<VerseRepo>();
    final items=await verseRepo.getListVerses(listId);
    var text="";
    for(var item in items){
      text+="""${item.surahId}/${item.surahName}\n${item.verseNumber} - ${item.content}\n\n\n""";
    }
    return text;
  }

}