
import 'package:flutter/material.dart';
import 'package:hadith/models/i_add_list_common.dart';

import '../../paging/i_paging_loader.dart';

class EditSelectListModel{
  final BuildContext context;
  final IAddListCommon listCommon;
  final int favoriteListId;
  final IPagingLoader loader;
  final Function updateArea;

  EditSelectListModel({required this.context,required this.listCommon,required this.favoriteListId,
    required this.loader,required this.updateArea});
}