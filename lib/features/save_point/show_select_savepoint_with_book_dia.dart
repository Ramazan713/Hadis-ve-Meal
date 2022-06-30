import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/widgets/custom_button_positive.dart';
import 'package:hadith/constants/enums/book_enum.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/constants/enums/sourcetype_enum.dart';
import 'package:hadith/utils/sourcetype_helper.dart';
import 'package:hadith/db/entities/savepoint.dart';
import 'package:hadith/features/hadith/hadith_router.dart';
import 'package:hadith/features/paging/paging_argument.dart';
import 'package:hadith/features/paging/paging_loader_factory.dart';
import 'package:hadith/features/save_point/bloc/save_point_edit_event.dart';
import 'package:hadith/features/save_point/widget/save_point_bloc_runner.dart';
import 'package:hadith/features/verse/verse_screen.dart';

import '../../models/save_point_argument.dart';
import 'bloc/save_point_edit_bloc.dart';

void showSelectSavePointWithBookDia(BuildContext context,
    {bool showOriginText=true,
      required BookEnum bookEnum,required List<int>bookBinaryIds,
      OriginTag? filter,List<OriginTag>exclusiveTags=const []}) {

  final ValueNotifier<SavePoint?> selectedNotifier=ValueNotifier(null);
  final ValueNotifier<OriginTag?> dropDownNotifier=ValueNotifier(null);

  final ScrollController scrollController=ScrollController();

  List<DropdownMenuItem<OriginTag>> getDropDownItems(){
    List<DropdownMenuItem<OriginTag>>menuItems=[];
    List<OriginTag> tags=OriginTag.values.toList();
    for(var tag in exclusiveTags){
      tags.remove(tag);
    }
    menuItems.add(DropdownMenuItem(child: Text("Seçilmedi",style: Theme.of(context).textTheme.subtitle1,),value: null,));
    for(var item in tags){
      menuItems.add(DropdownMenuItem(child: Text(item.shortName),value: item,));
    }
    return menuItems;
  }

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final editPointBloc = context.read<SavePointEditBloc>();
        editPointBloc.add(SavePointEditEventRequestWithBook(bookBinaryIds: bookBinaryIds,
            filter: filter));

        final String title;
        if(filter!=null){
          title="${filter.shortName} Kayıt Noktaları";
        }else{
          title="${SourceTypeHelper.getNameWithBookBinaryId(bookEnum.bookIdBinary)} Kayıt Noktaları";
        }

        return DraggableScrollableSheet(
          minChildSize: 0.3,
          initialChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollControllerDraggable) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CustomScrollView(
                    controller: scrollControllerDraggable,
                    shrinkWrap: true,
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  filter!=null?const SizedBox():Padding(
                                    padding: const EdgeInsets.only(left: 5,top: 5),
                                    child: ValueListenableBuilder(
                                      valueListenable: dropDownNotifier,
                                      builder: (context,value,child){
                                        return DropdownButton<OriginTag>(items:getDropDownItems(), onChanged: (selected){
                                          dropDownNotifier.value=selected;
                                          editPointBloc.add(SavePointEditEventRequestWithBook(bookBinaryIds: bookBinaryIds,
                                              filter: selected));
                                        },value: dropDownNotifier.value,);
                                      },),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        size: 27,
                                      ))
                                ],
                              ),
                              Text(title,textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline6,),
                              const SizedBox(height: 13,),

                              SavePointBlocRunner(scrollController: scrollController,
                                  showOriginText: showOriginText,
                                  selectedNotifier: selectedNotifier),
                            ]
                          )
                      )
                    ],
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: CustomButtonPositive(
                        onTap: () {
                          final selectedSavePoint=selectedNotifier.value;
                          if(selectedSavePoint!=null){
                            final label=selectedSavePoint.parentName;
                            final loader=PagingLoaderFactory.getLoader(bookEnum,selectedSavePoint.bookIdBinary,
                                selectedSavePoint.savePointType, selectedSavePoint.parentKey,
                                context);
                            final argument=PagingArgument(originTag: selectedSavePoint.savePointType,
                                savePointArg: SavePointArg(parentKey: selectedSavePoint.parentKey,id: selectedSavePoint.id),
                                bookIdBinary: selectedSavePoint.bookIdBinary,
                                loader: loader,title:label);

                            switch(SourceTypeHelper.getSourceTypeWithBookBinaryId(selectedSavePoint.bookIdBinary)){
                              case SourceTypeEnum.hadith:
                                routeHadithPage(context,argument);
                                break;
                              case SourceTypeEnum.verse:
                                Navigator.pushNamed(context, VerseScreen.id,arguments: argument);
                                break;
                            }
                          }
                        },
                        label: "Yükle ve Git",
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        );
      });
}
