

import 'package:flutter/material.dart';
import 'package:hadith/constants/enums/book_enum.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/constants/enums/sourcetype_enum.dart';
import 'package:hadith/utils/sourcetype_helper.dart';
import 'package:hadith/features/paging/hadith_loader/hadith_list_paging_loader.dart';
import 'package:hadith/features/paging/hadith_loader/hadith_search_paging_loader.dart';
import 'package:hadith/features/paging/hadith_loader/hadith_serlevha_paging_loader.dart';
import 'package:hadith/features/paging/hadith_loader/hadith_sitte_paging_loader.dart';
import 'package:hadith/features/paging/hadith_loader/hadith_topic_paging_loader.dart';
import 'package:hadith/features/paging/hadith_loader/i_paging_hadith_loader.dart';
import 'package:hadith/features/paging/verse_loader/i_paging_verse_loader.dart';
import 'package:hadith/features/paging/verse_loader/verse_cuz_paging_loader.dart';
import 'package:hadith/features/paging/verse_loader/verse_list_paging_loader.dart';
import 'package:hadith/features/paging/verse_loader/verse_paging_loader.dart';
import 'package:hadith/features/paging/verse_loader/verse_search_paging_loader.dart';
import 'package:hadith/features/paging/verse_loader/verse_surah_paging_loader.dart';
import 'package:hadith/features/paging/verse_loader/verse_topic_paging_loader.dart';

import 'i_paging_loader.dart';

class PagingLoaderFactory{

  static IPagingVerseLoader _getVerseLoader(OriginTag originTag,String parentKey,BuildContext context){
    IPagingVerseLoader selected;
    int? parentId=int.tryParse(parentKey);
    switch(originTag){
      case OriginTag.all:
        selected=VersePagingLoader(context: context);
        break;
      case OriginTag.cuz:
        selected=VerseCuzPagingLoader(context: context,cuzNo: parentId??0);
        break;
      case OriginTag.list:
        selected=VerseListPagingLoader(context: context,listId: parentId??0);
        break;
      case OriginTag.surah:
        selected=VerseSurahPagingLoader(context: context,surahId: parentId??0);
        break;
      case OriginTag.topic:
        selected=VerseTopicPagingLoader(context: context,topicId: parentId??0);
        break;
      case OriginTag.search:
        selected=VerseSearchPagingLoader(context, searchKey: parentKey);
        break;
      default:
        selected=VersePagingLoader(context: context);
        break;

    }
    return selected;
  }

  static IPagingHadithLoader _getHadithLoader(OriginTag originTag,BookEnum bookEnum,
     String parentKey,BuildContext context){
    IPagingHadithLoader selected;
    int? parentId=int.tryParse(parentKey);
    switch(originTag){
      case OriginTag.all:
        if(BookEnum.serlevha==bookEnum){
          selected=HadithSerlevhaPagingLoader(context: context);
        }else{
          selected=HadithSittePagingLoader(context: context);
        }
        break;
      case OriginTag.list:
        selected=HadithListPagingLoader(context: context,listId: parentId??0);
        break;
      case OriginTag.topic:
        selected=HadithTopicPagingLoader(context: context,topicId: parentId??0);
        break;
      case OriginTag.search:
        selected=HadithSearchPagingLoader(context, searchKey: parentKey);
        break;
      default:
        selected=HadithSerlevhaPagingLoader(context: context);
        break;
    }
    return selected;
  }


  static IPagingLoader getLoader(BookEnum bookEnum,int itemBookBinaryId
      ,OriginTag originTag,String parentKey,BuildContext context){

    switch(SourceTypeHelper.getSourceTypeWithBookBinaryId(itemBookBinaryId)){
      case SourceTypeEnum.hadith:
        return _getHadithLoader(originTag, bookEnum,parentKey, context);
      case SourceTypeEnum.verse:
        return _getVerseLoader(originTag, parentKey, context);
    }
  }

  static IPagingLoader getLoaderWithBookBinaryId(int itemBookBinaryId
      ,OriginTag originTag,String parentKey,BuildContext context){
    final BookEnum bookEnum=itemBookBinaryId==BookEnum.sitte.bookIdBinary?
        BookEnum.sitte:BookEnum.serlevha;

    return getLoader(bookEnum, itemBookBinaryId, originTag, parentKey, context);
  }


}