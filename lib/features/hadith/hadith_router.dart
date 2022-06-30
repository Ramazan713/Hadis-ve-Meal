

import 'package:flutter/material.dart';
import 'package:hadith/features/paging/paging_argument.dart';

import 'hadith_page_scrollable.dart';

void routeHadithPage(BuildContext context,PagingArgument argument)async{
  Navigator.pushNamed(context, HadithPageScrollable.id, arguments: argument);
}
