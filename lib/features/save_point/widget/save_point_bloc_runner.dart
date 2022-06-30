
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hadith/constants/enums/data_status_enum.dart';
import 'package:hadith/db/entities/savepoint.dart';
import 'package:hadith/dialogs/edit_text_bottom_dia.dart';
import 'package:hadith/dialogs/show_custom_alert_bottom_dia.dart';
import 'package:hadith/features/save_point/bloc/save_point_edit_bloc.dart';
import 'package:hadith/features/save_point/bloc/save_point_edit_event.dart';
import 'package:hadith/features/save_point/bloc/save_point_edit_state.dart';
import 'package:hadith/features/save_point/widget/save_point_item.dart';

import '../../../utils/toast_utils.dart';

class SavePointBlocRunner extends StatelessWidget {
  final ScrollController scrollController;
  final ValueNotifier<SavePoint?> selectedNotifier;
  final bool showOriginText;

  const SavePointBlocRunner({Key? key,required this.scrollController,
    required this.selectedNotifier,required this.showOriginText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editPointBloc = context.read<SavePointEditBloc>();


    return BlocBuilder<SavePointEditBloc, SavePointEditState>(
        builder: (context, state) {
          if(state.status==DataStatus.loading){
            return const Center(child: CircularProgressIndicator(),);
          }
          final items = state.savePoints;

          if(items.isEmpty){
            return  Center(child: Text("Herhangi bir kayıt bulunamadı",
              style: Theme.of(context).textTheme.bodyText2,),);
          }

          return ListView.builder(
            shrinkWrap: true,
            controller: scrollController,
            itemBuilder: (context, index) {
              final item = items[index];

              return ValueListenableBuilder(
                valueListenable: selectedNotifier,
                builder: (context,value,child){
                  return GestureDetector(
                    onTap: (){
                      selectedNotifier.value=item;
                    },
                    child: SavePointItem(item: item,
                      showOriginText: showOriginText,
                      isSelected: selectedNotifier.value==item,
                      editTitleListener: (){
                        showEditTextBottomDia(context, (newText){
                          editPointBloc.add(SavePointEditEventRename(savePoint: item,
                              newTitle: newText));
                          ToastUtils.showLongToast("Yeniden İsimlendirildi");
                        },title: "Yeniden Adlandır",content: item.title);
                      },removeItemListener: (){
                        showCustomAlertBottomDia(context,title: "Silmek İstediğinize emin misiniz?",
                            btnApproved: (){
                              selectedNotifier.value=null;
                              editPointBloc.add(SavePointEditEventDelete(savePoint: item));
                              ToastUtils.showLongToast("Silindi");
                            });
                      },),
                  );
                },
              );
            },
            itemCount: items.length,
          );
        });
  }
}
