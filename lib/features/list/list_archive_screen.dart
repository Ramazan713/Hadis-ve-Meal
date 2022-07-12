

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/list_edit_enum.dart';
import 'package:hadith/dialogs/edit_text_bottom_dia.dart';
import 'package:hadith/dialogs/show_bottom_select_menu_items_enum.dart';
import 'package:hadith/features/list/bloc/list_count_event.dart';
import 'package:hadith/features/list/list_funcs.dart';
import 'package:hadith/features/list/widget/list_tile_item.dart';
import 'package:hadith/features/paging/my_extractor_glow_behavior.dart';
import 'package:hadith/utils/sourcetype_helper.dart';
import 'package:hadith/utils/toast_utils.dart';
import 'package:hadith/widgets/custom_sliver_appbar.dart';
import 'package:hadith/widgets/custom_sliver_nested_scrollview.dart';

import '../../constants/enums/data_status_enum.dart';
import '../../db/entities/views/i_list_view.dart';
import 'bloc/blocs/list_archive_bloc.dart';
import 'bloc/state/list_archive_state.dart';

class ListArchiveScreen extends StatelessWidget {
  static const id="ListArchiveScreen";
  const ListArchiveScreen({Key? key}) : super(key: key);

  void _executeMenu(IListView item, BuildContext context,ListArchiveBloc bloc) {

    List<ListEditEnum> listEnums = [
      ListEditEnum.rename,
      ListEditEnum.remove,
      ListEditEnum.exportAs,
      ListEditEnum.unArchive,
    ];

    final items=getAskedListIconTextItems(context,
        listEnums: listEnums,isPop: true,item: item,
        selectedItem: (listEnum){
          switch (listEnum) {
            case ListEditEnum.rename:
              showEditTextBottomDia(context, (newText) {
                bloc.add(ListCountEventRenamed(newText: newText, listView: item));
              }, title: "Yeniden İsimlendir", content: item.name);
              break;
            case ListEditEnum.remove:
              bloc.add(ListCountEventRemoved(item));
              break;
            case ListEditEnum.exportAs:
              break;
            case ListEditEnum.newCopy:
              break;
            case ListEditEnum.archive:
              break;
            case ListEditEnum.unArchive:
              bloc.add(ListCountEventArchive(listView: item, isArchive: false));
              ToastUtils.showLongToast("Arşivden çıkarıldı");
              break;
            case ListEditEnum.removeItems:
              break;
          }
        });

    showSelectMenuItemDia(context, items: items,title: "'${item.name}' listesi için");
  }

  Widget getEmptyWidget(BuildContext context) {
    return Center(
      child: ScrollConfiguration(
        behavior: MyExtractorGlowBehavior(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.library_add_check_outlined,
                size: 150,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Arşiv'e listeler ekleyebilirsiniz",
                style: Theme.of(context).textTheme.headline6,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }

    @override
  Widget build(BuildContext context) {
    final archiveBloc=context.read<ListArchiveBloc>();
    archiveBloc.add(const ListCountEventItemsRequested());

    return Scaffold(
      body: SafeArea(
        child: CustomSliverNestedView(context,
          isBottomNavAffected: false,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return [
              const CustomSliverAppBar(
                title: Text("Arşiv"),
              )
            ];
          },
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ListArchiveBloc,ListArchiveState>(
                    builder: (context, state) {
                      if (state.status == DataStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final items=state.listItems;

                      if(items.isEmpty){
                       return getEmptyWidget(context);
                      }

                      return ListView.builder(
                        itemBuilder: (context, index) {
                          var item = items[index];
                          final sourceType=SourceTypeHelper.getSourceTypeWithSourceId(item.sourceId);
                          return ListTileItem(
                              sourceTypeEnum: sourceType,
                              defaultIcon: getListItemIcon(sourceType, context),
                              listModel: item,
                              onTap: () {
                                navigateToFromList(sourceType, item, context);
                              },
                              menuListener: () {
                                _executeMenu(item, context,archiveBloc);
                              });
                        },
                        itemCount: items.length,
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
