import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hadith/constants/enums/sourcetype_enum.dart';
import 'package:hadith/db/entities/views/i_list_view.dart';

import '../../constants/enums/book_enum.dart';
import '../../constants/enums/list_edit_enum.dart';
import '../../constants/enums/origin_tag_enum.dart';
import '../../dialogs/show_custom_alert_bottom_dia.dart';
import '../../models/save_point_argument.dart';
import '../../utils/sourcetype_helper.dart';
import '../../widgets/menu_item_tile.dart';
import '../hadith/hadith_router.dart';
import '../paging/hadith_loader/hadith_list_paging_loader.dart';
import '../paging/paging_argument.dart';
import '../paging/verse_loader/verse_list_paging_loader.dart';
import '../../utils/share_utils.dart';
import '../share/show_share_alert_dialog.dart';
import '../share/widget/list_tile_share_item.dart';
import '../verse/verse_screen.dart';

Icon getListItemIcon(SourceTypeEnum sourceTypeEnum,BuildContext context){
  switch(sourceTypeEnum){
    case SourceTypeEnum.hadith:
      return Icon(
          Icons.my_library_books,
          size: 30,
          color: Theme.of(context).iconTheme.color
      );
    case SourceTypeEnum.verse:
      return Icon(
          FontAwesomeIcons.bookQuran,
          size: 30,
          color: Theme.of(context).iconTheme.color
      );
  }
}

void navigateToFromList(SourceTypeEnum sourceTypeEnum,IListView item, BuildContext context){
  switch(sourceTypeEnum){
    case SourceTypeEnum.hadith:
      var loader = HadithListPagingLoader(context: context, listId: item.id);
      routeHadithPage(
          context,
          PagingArgument(
              title: item.name,
              loader: loader,
              savePointArg: SavePointArg(parentKey: item.id.toString()),
              bookIdBinary:
              BookEnum.serlevha.bookIdBinary | BookEnum.sitte.bookIdBinary,
              originTag: OriginTag.list));
     break;
    case SourceTypeEnum.verse:
      final arg = PagingArgument(
          savePointArg: SavePointArg(parentKey: item.id.toString()),
          bookIdBinary: BookEnum.dinayetMeal.bookIdBinary,
          title: item.name,
          originTag: OriginTag.list,
          loader: VerseListPagingLoader(context: context, listId: item.id));
      Navigator.pushNamed(context, VerseScreen.id, arguments: arg);
      break;
  }
}

List<IconTextItem>getAskedListIconTextItems(BuildContext context,
    {required void Function(ListEditEnum)selectedItem,required List<ListEditEnum>listEnums,
    bool isPop=false,required IListView item}){

  List<IconTextItem> items = [];
  for(var listEnum in listEnums){
    items.add(
        IconTextItem(title: listEnum.name, iconData: listEnum.iconData,
            onTap: () {
              if(isPop){
                Navigator.pop(context);
              }
              switch (listEnum) {
                case ListEditEnum.rename:
                  selectedItem.call(listEnum);
                  break;
                case ListEditEnum.remove:
                  if (item.isRemovable) {
                    showCustomAlertBottomDia(context,
                        title: "Silmek istediğinize emin misiniz?",
                        content: "Bu işlem geri alınamaz", btnApproved: () {
                          selectedItem.call(listEnum);
                        });
                  }
                  break;
                case ListEditEnum.exportAs:
                  showShareAlertDialog(context, listItems: [
                    ListTileShareItem(
                        title: "PDF Olarak Paylaş", onTap: () async {
                      ShareUtils.sharePdf(context, item,
                          SourceTypeHelper.getSourceTypeWithSourceId(
                              item.sourceId));
                    }, iconData: FontAwesomeIcons.filePdf),
                    ListTileShareItem(title: "Yazı Olarak Paylaş", onTap: () {
                      ShareUtils.shareTextWithList(context, item.id,
                          SourceTypeHelper.getSourceTypeWithSourceId(
                              item.sourceId));
                    }, iconData: Icons.text_format),
                  ]);
                  break;
                case ListEditEnum.newCopy:

                  showCustomAlertBottomDia(context,
                      title: "Yeni bir kopya oluştumak istediğinize emin misiniz",
                      btnApproved: () {
                        selectedItem.call(listEnum);
                      });
                  break;
                case ListEditEnum.archive:
                  showCustomAlertBottomDia(
                      context, title: "Arşivlemek istediğinize emin misiniz?",
                      content: "Arşivlenen listeler yalnızca arşiv kısmında kullanılabilir",
                      btnApproved: () {
                        selectedItem.call(listEnum);
                      });
                  break;
                case ListEditEnum.unArchive:
                  showCustomAlertBottomDia(
                      context, title: "Arşivden çıkarmak istediğinize emin misiniz?",
                      btnApproved: () {
                        selectedItem.call(listEnum);
                      });
                  break;
                case ListEditEnum.removeItems:
                  final SourceTypeEnum sourceTypeEnum = SourceTypeHelper.getSourceTypeWithSourceId(item.sourceId);
                  final key=sourceTypeEnum==SourceTypeEnum.hadith?"hadisleri":"ayetleri";
                  showCustomAlertBottomDia(context,title: "Listedeki $key silmek istediğinize emin misiniz?",
                  content: "Bu işlem geri alınamaz",btnApproved: (){
                        selectedItem.call(listEnum);
                      });
                  break;
              }
            }));
  }
  return items;
}



