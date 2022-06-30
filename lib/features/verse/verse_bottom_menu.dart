import 'package:flutter/material.dart';
import 'package:hadith/constants/enums/verse_edit_enum.dart';
import 'package:hadith/db/entities/verse.dart';
import 'package:hadith/widgets/menu_item_tile.dart';

void showVerseBottomMenu(BuildContext context,{required Function(VerseEditEnum)listener,
  required bool isAddListNotEmpty,required bool isFavorite,required Verse verse
}) {
  final ValueNotifier<bool>_rebuildNotifier=ValueNotifier(false);

  showModalBottomSheet(
    isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: ValueListenableBuilder(valueListenable: _rebuildNotifier,
              builder: (context,value,child){
            return Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 7,),
                  Text("${verse.surahName} ${verse.verseNumber}. Ayet",textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,),
                  const SizedBox(height: 5,),
                  IconTextItem(
                    title: "Paylaş",
                    iconData: Icons.share,
                    onTap: () {
                      listener.call(VerseEditEnum.share);
                    },
                  ),
                  IconTextItem(
                    title: "İçeriği Kopyala",
                    iconData: Icons.copy,
                    onTap: () {
                      listener.call(VerseEditEnum.copy);
                    },
                  ),
                  IconTextItem(
                    title: isAddListNotEmpty?"Listeden Çıkar":"Listeye Ekle",
                    iconData: isAddListNotEmpty?Icons.library_add_check:Icons.library_add,
                    onTap: () {
                      listener.call(VerseEditEnum.addList);
                    },
                  ),
                  IconTextItem(
                    iconColor: isFavorite?Colors.red:null,
                    title: isFavorite?"Favoriden Çıkar":"Favoriye Ekle",
                    iconData: Icons.favorite,
                    onTap: () {
                      listener.call(VerseEditEnum.addFavorite);
                      isFavorite=!isFavorite;
                      _rebuildNotifier.value=!_rebuildNotifier.value;
                    },
                  ),
                  IconTextItem(title: "Kayıt Noktası Oluştur", iconData: Icons.save,
                      onTap: (){
                        listener.call(VerseEditEnum.savePoint);
                      })
                ],
              ),
            );
              }),
        );
      });
}