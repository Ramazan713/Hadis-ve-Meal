

import 'package:hadith/constants/enums/book_enum.dart';
import 'package:hadith/constants/enums/origin_tag_enum.dart';
import 'package:hadith/features/paging/paging_argument.dart';
import 'package:hadith/models/save_point_argument.dart';

import 'default_paging_loader.dart';

class DefaultPagingArgument extends PagingArgument{
  DefaultPagingArgument() : super(
    savePointArg: SavePointArg(parentKey: "0"),
    originTag: OriginTag.all,
    bookIdBinary: BookEnum.serlevha.bookIdBinary,
    title: "Liste",
    loader: DefaultPagingLoader(),
  );
}