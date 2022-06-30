import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/features/bottom_nav/widget/bottom_nav_widget_state.dart';
import 'package:hadith/features/search/search_funcs.dart';
import 'package:hadith/widgets/custom_button_positive.dart';
import 'package:hadith/constants/common_menu_items.dart';
import 'package:hadith/constants/enums/book_enum.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/features/history/bloc/history_bloc.dart';
import 'package:hadith/features/history/bloc/history_event.dart';
import 'package:hadith/features/history/bloc/history_state.dart';
import 'package:hadith/features/history/widget/history_item.dart';
import 'package:hadith/features/save_point/show_select_savepoint_with_book_dia.dart';
import 'package:hadith/features/search/bloc/search_bloc.dart';
import 'package:hadith/features/search/bloc/search_event.dart';
import 'package:hadith/features/search/bloc/search_state.dart';
import 'package:hadith/features/search/widget/search_item.dart';
import 'package:hadith/widgets/custom_sliver_appbar.dart';
import 'package:hadith/widgets/custom_sliver_nested_scrollview.dart';

class SearchPage extends StatefulWidget {
  static const id = "SearchPage";
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends BottomNavWidgetState<SearchPage> {
  final TextEditingController textEditingController = TextEditingController();

  final ValueNotifier<String>_resultTextNotifier=ValueNotifier("");
  var isSearching=false;

  void requestData(SearchBloc bloc,String searchKey,BuildContext context){
    if(searchKey!=""){
      bloc.add(SearchEventRequestResult(searchKey: searchKey));
      setState(() {
        isSearching=true;
      });
      FocusScope.of(context).unfocus();
    }else{
      resetSearchState(bloc);
    }
  }

  void resetSearchState(SearchBloc bloc){
    bloc.add(SearchEventResetState());
    setState(() {
      isSearching=false;
    });
  }

  @override
  Widget buildPage(BuildContext context) {

    final textBodyStyle2=Theme.of(context).textTheme.bodyText2;

    final SearchBloc searchBloc=context.read<SearchBloc>();
    final HistoryBloc historyBloc=context.read<HistoryBloc>();
    searchBloc.add(SearchEventResetState());
    historyBloc.add(HistoryEventRequest(originTag: OriginTag.search));

    return Scaffold(
      body: SafeArea(
          child: CustomSliverNestedView(
            context,
            isBottomNavAffected: true,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return [
                CustomSliverAppBar(
                  title: const Text("Arama"),
                  actions: [
                    getSavePointIcon(onPress: (){
                      showSelectSavePointWithBookDia(context,
                          bookEnum: BookEnum.none, bookBinaryIds:[
                            BookEnum.sitte.bookIdBinary,BookEnum.serlevha.bookIdBinary,
                            BookEnum.sitte.bookIdBinary|BookEnum.serlevha.bookIdBinary,
                            BookEnum.dinayetMeal.bookIdBinary
                          ],filter: OriginTag.search);
                    }),
                    getSettingIcon(context),
                  ],
                ),
                SliverList(delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 27, horizontal: 19),
                        child: TextField(
                          onSubmitted: (text){
                            if(text.trim()!=""){
                              requestData(searchBloc,text.trim(),context);
                            }
                          },
                          controller: textEditingController,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                textEditingController.clear();
                                resetSearchState(searchBloc);
                              },
                            ),
                            hintText: "Ara",

                          ),
                        ),
                      ),
                    ]
                ))
              ];
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Visibility(
                  visible: isSearching,
                  child: ValueListenableBuilder<String>(valueListenable: _resultTextNotifier,
                      builder: (context,value,child){
                        return value!=""?Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 19),
                            child: RichText(text: TextSpan(
                                children: [
                                  TextSpan(text: "$value ",style:textBodyStyle2?.copyWith(fontWeight: FontWeight.w700)),
                                  const TextSpan(text: "kelimesinin sonuçları")
                                ],
                                style: textBodyStyle2
                            ),
                            )):const SizedBox();
                      }),
                ),
                Visibility(
                  visible: isSearching,
                  child: Expanded(
                      child: BlocConsumer<SearchBloc,SearchState>(
                        listener: (context,state){
                          if(state.status==DataStatus.success){
                            _resultTextNotifier.value=state.searchKey;
                            historyBloc.add(HistoryEventInsert(searchText: state.searchKey,
                                originTag: OriginTag.search));
                          }
                        },
                        builder: (context,state){
                          if(state.status==DataStatus.loading){
                            return const Center(child: CircularProgressIndicator(),);
                          }
                          final items=getResultModels(context, state);

                          if(items.isEmpty){
                            return Center(
                              child: Text("Herhangi bir sonuç bulunamadı",style: textBodyStyle2,),
                            );
                          }

                          return ListView.builder(
                            itemBuilder: (context, index) {
                              final item=items[index];
                              return SearchItem(
                                title: item.title,
                                onForwardClick: () {
                                  item.navigate(context);
                                },
                                position: index+1,
                                resultCount: item.resultCount,
                              );
                            },
                            itemCount: items.length,
                          );
                        },
                      )),
                ),
                Visibility(
                  visible: !isSearching,
                  child: BlocBuilder<HistoryBloc,HistoryState>(
                    builder: (context,state){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 19),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("geçmiş ",style: textBodyStyle2,),
                            TextButton(onPressed: (){
                              historyBloc.add(HistoryEventRemoveItems(historyEntities: state.historyEntities));
                            }, child: Text("temizle",style: textBodyStyle2?.copyWith(fontWeight: FontWeight.w600),))
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Visibility(
                  visible: !isSearching,
                  child: Expanded(child: BlocBuilder<HistoryBloc,HistoryState>(
                    builder: (context,state){
                      if(state.status==DataStatus.loading){
                        return const Center(child: CircularProgressIndicator(),);
                      }
                      final items=state.historyEntities;

                      if(items.isEmpty){
                        return Center(child: Text("geçmiş bulunmamaktadır",style: textBodyStyle2,),);
                      }

                      return ListView.builder(itemBuilder: (context,index){
                        final item=items[index];
                        return HistoryItem(historyEntity: item,onClick: (){
                          requestData(searchBloc, item.name,context);
                          textEditingController.text=item.name;
                        },onRemoveClick: (){
                          historyBloc.add(HistoryEventRemoveItem(historyEntity: item));
                        },);
                      },itemCount: items.length,);
                    },
                  )),
                ),
                CustomButtonPositive(
                  onTap: () {
                    final String text = textEditingController.text.trim();
                    if (text != "") {
                      requestData(searchBloc, text,context);
                    }
                  },
                  label: "Ara",
                ),
              ],
            ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }
}
