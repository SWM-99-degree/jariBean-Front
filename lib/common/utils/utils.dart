import 'package:jari_bean/common/const/data.dart';

class Utils {
  static pathToUrl(String path) {
    return '$ip/$path';
  }

  static DateTime truncateToQuaterHour(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      date.hour,
      (date.minute / 15).round() * 15,
    );
  }

}
