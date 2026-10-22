import 'package:jiffy/jiffy.dart';

extension DatetimeExtension on DateTime {
  String format(String pattern) {
    return Jiffy.parseFromDateTime(this).format(pattern: pattern);
  }

  String formatToDate([String pattern = "yyyy-MM-dd"]) {
    return format(pattern);
  }

  String formatToDatetime([String pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"]) {
    return format(pattern);
  }
}
