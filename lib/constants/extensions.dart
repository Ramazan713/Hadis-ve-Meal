

import 'package:intl/intl.dart';

extension DateTimeFormats on DateTime{
  static String formatDate1(String dateText){
    final DateFormat formatter = DateFormat('d MMM yyyy HH:mm');
    return formatter.format(DateTime.parse(dateText));
  }
}