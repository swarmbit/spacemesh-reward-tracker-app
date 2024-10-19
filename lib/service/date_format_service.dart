import 'dart:ui';

import 'package:intl/intl.dart';

class DateFormatService {
  static final DateFormatService _singleton = DateFormatService._internal();


  DateFormatService._internal();

  factory DateFormatService() {
    return _singleton;
  }

  String formatWithLocale(Locale locale, DateTime date) {
    var dateFormat = DateFormat.yMMMd(locale.toLanguageTag());
    var timeFormat = DateFormat.Hm(locale.toLanguageTag());
    return  "${dateFormat.format(date)} at ${timeFormat.format(date)}";
  }


}