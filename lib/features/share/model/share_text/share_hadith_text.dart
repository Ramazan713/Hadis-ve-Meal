import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/db/entities/hadith.dart';
import 'package:hadith/db/repos/hadith_repo.dart';
import 'package:hadith/features/share/model/share_text/i_share_text.dart';

class ShareHadithText extends IShareText<Hadith>{
  @override
  String getSharedText(Hadith item) {
    return "${item.content}\n\t- ${item.source}\n";
  }

  @override
  Future<String> getSharedTextWithList(BuildContext context,int listId) async{
    final hadithRepo=context.read<HadithRepo>();
    final items=await hadithRepo.getListHadiths(listId);
    var text="";
    for(var item in items){
      text+="${item.content}\n\t- ${item.source}\n\n\n";
    }
    return text;
  }

}