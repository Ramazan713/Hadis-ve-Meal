

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hadith/features/home/widget/home_book_item.dart';
import 'package:hadith/features/home/widget/home_sub_item.dart';

import '../../constants/enums/book_enum.dart';
import '../../constants/enums/origin_tag_enum.dart';
import '../../models/save_point_argument.dart';
import '../hadith/hadith_router.dart';
import '../paging/hadith_loader/hadith_serlevha_paging_loader.dart';
import '../paging/hadith_loader/hadith_sitte_paging_loader.dart';
import '../paging/paging_argument.dart';
import '../save_point/show_select_savepoint_with_book_dia.dart';
import '../topic/model/section_argument.dart';
import '../topic/section_screen.dart';
import '../verse/cuz/cuz_screen.dart';
import '../verse/surah/surah_screen.dart';


final List<String> homeTitles = [
  "Serlevha",
  "Kütübi Sitte",
  "Kur'an Dinayet"
];

List<HomeBookItem>getHomeItems(BuildContext context,{required OriginTag originTag}){
  return [
    HomeBookItem(
        item1: HomeSubItem(
          title: "Tümü",
          iconData: Icons.all_inclusive,
          onTap: () {
            var loader = HadithSerlevhaPagingLoader(context: context);
            routeHadithPage(
                context,
                PagingArgument(
                    savePointArg: SavePointArg(parentKey: BookEnum.serlevha.bookId.toString()),
                    bookIdBinary: BookEnum.serlevha.bookIdBinary,
                    title: "Tümü",
                    loader: loader,
                    originTag: originTag));
          },
        ),
        item2: HomeSubItem(
          title: "Konular",
          iconData: FontAwesomeIcons.bookOpenReader,
          onTap: () {
            final sectionArgument =
            SectionArgument(bookEnum: BookEnum.serlevha);
            Navigator.pushNamed(context, SectionScreen.id,
                arguments: sectionArgument);
          },
        ),
        item3: HomeSubItem(
          title: "Kayıt Noktaları",
          iconData: Icons.save,
          onTap: () {
            showSelectSavePointWithBookDia(context,
                bookEnum: BookEnum.serlevha,
                bookBinaryIds: [
                  BookEnum.serlevha.bookIdBinary,
                  BookEnum.sitte.bookIdBinary | BookEnum.serlevha.bookIdBinary
                ],
                exclusiveTags: [
                  OriginTag.surah,
                  OriginTag.cuz
                ]);
          },
        ),
        title: homeTitles[0]), //Serlevha

    HomeBookItem(
        item1: HomeSubItem(
          title: "Tümü",
          iconData: Icons.all_inclusive,
          onTap: () {
            var loader = HadithSittePagingLoader(context: context);
            routeHadithPage(
                context,
                PagingArgument(
                    savePointArg: SavePointArg(parentKey:BookEnum.sitte.bookId.toString() ),
                    bookIdBinary: BookEnum.sitte.bookIdBinary,
                    title: "Tümü",
                    loader: loader,
                    originTag: originTag));
          },
        ),
        item2: HomeSubItem(
          title: "Konular",
          iconData: FontAwesomeIcons.bookOpenReader,
          onTap: () {
            final sectionArgument = SectionArgument(bookEnum: BookEnum.sitte);
            Navigator.pushNamed(context, SectionScreen.id,
                arguments: sectionArgument);
          },
        ),
        item3: HomeSubItem(
          title: "Kayıt Noktaları",
          iconData: Icons.save,
          onTap: () {
            showSelectSavePointWithBookDia(context,
                bookEnum: BookEnum.sitte,
                bookBinaryIds: [
                  BookEnum.sitte.bookIdBinary,
                  BookEnum.sitte.bookIdBinary | BookEnum.serlevha.bookIdBinary
                ],
                exclusiveTags: [
                  OriginTag.surah,
                  OriginTag.cuz
                ]);
          },
        ),
        title: homeTitles[1]), //Kütübi Sitte

    HomeBookItem(
        item1: HomeSubItem(
          title: "Konular",
          iconData: FontAwesomeIcons.bookOpenReader,
          onTap: () {
            final sectionArgument =
            SectionArgument(bookEnum: BookEnum.dinayetMeal);
            Navigator.pushNamed(context, SectionScreen.id,
                arguments: sectionArgument);
          },
        ),
        item2: HomeSubItem(
          title: "Cüz",
          iconData: FontAwesomeIcons.bookQuran,
          onTap: () {
            Navigator.pushNamed(context, CuzScreen.id);
          },
        ),
        item3: HomeSubItem(
          title: "Sure",
          iconData: FontAwesomeIcons.bookQuran,
          onTap: () {
            Navigator.pushNamed(context, SurahScreen.id);
          },
        ),
        item4: HomeSubItem(
          title: "Kayıt Noktaları",
          iconData: Icons.save,
          onTap: () {
            showSelectSavePointWithBookDia(context,
                bookEnum: BookEnum.dinayetMeal,
                bookBinaryIds: [BookEnum.dinayetMeal.bookIdBinary],
                exclusiveTags: [OriginTag.all]);
          },
        ),
        title: homeTitles[2]), //Dinayet Meal
  ];
}