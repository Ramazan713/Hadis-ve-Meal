

import 'package:flutter/material.dart';
import 'package:hadith/constants/enums/sourcetype_enum.dart';
import 'package:hadith/db/entities/hadith.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';
import 'package:hadith/features/share/model/share_image/hadith_share_image.dart';
import 'package:hadith/features/share/model/share_image/i_share_image.dart';
import 'package:hadith/features/share/model/share_image/verse_share_image.dart';
import 'package:hadith/features/share/model/share_pdf/hadith_share_pdf.dart';
import 'package:hadith/features/share/model/share_pdf/i_share_pdf.dart';
import 'package:hadith/features/share/model/share_pdf/verse_share_pdf.dart';
import 'package:hadith/features/share/model/share_text/i_share_text.dart';
import 'package:hadith/features/share/model/share_text/share_hadith_text.dart';
import 'package:hadith/utils/toast_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'loading_util.dart';
import '../features/share/model/share_text/share_verse_text.dart';
import 'dart:io';

class ShareUtils{

  static void _errorHandlingWithLoading(BuildContext context,Future<void> Function() function)async{
    try{
      LoadingUtil.requestLoading(context);
      await function.call();
    }catch(e){
      final errorText=e.toString().replaceAll("Exception:","").trim();
      ToastUtils.showLongToast(errorText!=""?errorText:"Bilinmeyen Bir Hata Oluştu");
    }finally{
      LoadingUtil.requestCloseLoading(context);
    }
  }

  static void sharePdf(BuildContext context,IListView item,SourceTypeEnum sourceTypeEnum)async{
    _errorHandlingWithLoading(context, ()async{
      final ISharePdf sharePdfClass;
      switch(sourceTypeEnum){
        case SourceTypeEnum.hadith:
          sharePdfClass=HadithSharePdf();
          break;
        case SourceTypeEnum.verse:
          sharePdfClass=ShareVersePDF();
          break;
      }
      final fileName=await sharePdfClass.getSharedFileName(context, item);
      Share.shareFiles([fileName],
        mimeTypes: ["application/pdf"],);
    });
  }

  static IShareImage shareImageExecutor(BuildContext context,SourceTypeEnum sourceTypeEnum){
    final IShareImage iShareImage;
    switch(sourceTypeEnum){
      case SourceTypeEnum.hadith:
        iShareImage=HadithShareImage();
        break;
      case SourceTypeEnum.verse:
        iShareImage=ShareVerseImage();
        break;
    }
    return iShareImage;
  }
  static void shareContent(String content){
    Share.share(content);
  }
  
  static void shareText(item,SourceTypeEnum sourceTypeEnum){
    final IShareText iShareText;
    switch(sourceTypeEnum){
      case SourceTypeEnum.hadith:
        iShareText=ShareHadithText();
        break;
      case SourceTypeEnum.verse:
        iShareText=ShareVerseText();
        break;
    }
    Share.share(iShareText.getSharedText(item));
  }

  static void shareTextWithList(BuildContext context,int listId,SourceTypeEnum sourceTypeEnum){
    _errorHandlingWithLoading(context, ()async{
      final IShareText iShareText;
      switch(sourceTypeEnum){
        case SourceTypeEnum.hadith:
          iShareText=ShareHadithText();
          break;
        case SourceTypeEnum.verse:
          iShareText=ShareVerseText();
          break;
      }
      String text=await iShareText.getSharedTextWithList(context, listId);
      if(text==""){
        throw Exception("Listede herhangi bir ${sourceTypeEnum.shortName} bulunmamaktadır");
      }
      Share.share(text);
    });
  }

  static void copyHadithText(Hadith hadith){
    Clipboard.setData(ClipboardData(text: ShareHadithText().getSharedText(hadith)));
    ToastUtils.showLongToast("Kopyalandı");
  }

  static void copyVerseText(Verse verse){
    Clipboard.setData(ClipboardData(text: ShareVerseText().getSharedText(verse)));
    ToastUtils.showLongToast("Kopyalandı");
  }

  static Future<String> getShareDirectoryPath({bool isRemoveFiles=true})async{
    final directoryPath = "${(await getExternalStorageDirectory())?.path}/Share";

    final directory=Directory(directoryPath);

    if(!directory.existsSync()){
    await directory.create(recursive: true);
    }else{
      if(isRemoveFiles){
        await directory.delete(recursive: true);
      }
    }
    return Future.value(directoryPath);
  }

}