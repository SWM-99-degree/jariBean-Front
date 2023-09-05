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

  static getButtonNameFromEnum<T>({
    required T enumValue,
    required Map<T, String> map,
  }) {
    return map[enumValue] ?? '';
  }

  static String getHHMMfromDateTime(DateTime dateTime) {
    return "${dateTime.hour}시 ${dateTime.minute == 0 ? '00' : dateTime.minute}분";
  }

  static String getMMSSfromDateSeconds(int timeLeftInSeconds) {
    int minutes = timeLeftInSeconds ~/ 60;
    int seconds = timeLeftInSeconds % 60;
    return "${minutes < 10 ? '0' : ''}$minutes : ${seconds < 10 ? '0' : ''}$seconds";
  }
}
