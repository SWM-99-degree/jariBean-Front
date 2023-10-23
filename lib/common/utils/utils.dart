import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/models/fcm_message_model.dart';

class Utils {
  static pathToUrl(String path) {
    return '$ip/$path';
  }

  static DateTime truncateToTimeUnit(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      date.hour,
      (date.minute / RESERVATION_TIME_UNIT).round() * RESERVATION_TIME_UNIT,
    );
  }

  static getButtonNameFromEnum<T>({
    required T enumValue,
    required Map<T, String> map,
  }) {
    return map[enumValue] ?? '';
  }

  static bool isDifferentDay(DateTime formerDate, DateTime latterDate) {
    return formerDate.year != latterDate.year ||
        formerDate.month != latterDate.month ||
        formerDate.day != latterDate.day;
  }

  static String getYYYYMMDDfromDateTime(DateTime dateTime) {
    return "${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}";
  }

  static String getYYYYMMDDHHMMfromDateTimeWithKorean(
    DateTime dateTime, {
    bool showHHMM = false,
  }) {
    return "${dateTime.year}년 ${dateTime.month.toString().padLeft(2, '0')}월 ${dateTime.day.toString().padLeft(2, '0')}일 ${showHHMM ? getHHMMfromDateTime(dateTime) : ''}";
  }

  static String getHHMMfromDateTime(DateTime dateTime) {
    return "${dateTime.hour}시${dateTime.minute == 0 ? '' : ' ${dateTime.minute}분'}";
  }

  static String getHHMMAmountfromDuration(Duration duration) {
    final minute = duration.inMinutes % 60;
    if (duration.inHours == 0) {
      return "$minute분";
    }
    return "${duration.inHours}시간${minute == 0 ? '' : ' $minute분'}";
  }

  static String getMMSSfromDateSeconds(int timeLeftInSeconds) {
    int minutes = timeLeftInSeconds ~/ 60;
    int seconds = timeLeftInSeconds % 60;
    return "${minutes < 10 ? '0' : ''}$minutes : ${seconds < 10 ? '0' : ''}$seconds";
  }

  /// given type, return PushMessageType enum.
  /// this is used to deserialize PushMessageType from json.
  /// see this : https://github.com/SWM-99-degree/jariBean-Front/issues/126
  static PushMessageType getPushMessageType(String type) {
    switch (type) {
      case 'matchingSuccess':
        return PushMessageType.matchingSuccess;
      case 'matchingFail':
        return PushMessageType.matchingFail;
      case 'matchingCancel':
        return PushMessageType.matchingCancel;
      case 'matchingUrgent':
        return PushMessageType.matchingUrgent;
      case 'announcement':
        return PushMessageType.announcement;
      case 'ads':
        return PushMessageType.ads;
      case 'reservationInfo':
        return PushMessageType.reservationInfo;
      case 'reservationComplete':
        return PushMessageType.reservationComplete;
      case 'reservationCanceled':
        return PushMessageType.reservationCanceled;
      case 'reservationUrgent':
        return PushMessageType.reservationUrgent;
      default:
        throw Exception('Unknown push message type: $type');
    }
  }

  /// given type and data, return FcmDataModelBase based on its type.
  /// this is used to deserialize FcmDataModelBase from json.
  /// for convenience, parameter `type` is String, not PushMessageType.
  /// and it must be one of PushMessageType enum.
  /// see this : https://github.com/SWM-99-degree/jariBean-Front/issues/126
  static FcmDataModelBase getPushMessageData({
    required String type,
    required Map<String, dynamic> data,
  }) {
    switch (type) {
      case 'matchingSuccess':
        return MatchingSuccessModel.fromJson(data);
      case 'matchingFail':
        return MatchingFailModel.fromJson(data);
      case 'matchingCancel':
        return MatchingCancelModel.fromJson(data);
      case 'matchingUrgent':
        return MatchingUrgentModel.fromJson(data);
      case 'announcement':
        return AnnouncementDataModel.fromJson(data);
      case 'ads':
        return AdsDataModel.fromJson(data);
      case 'reservationInfo':
        return ReservationDataModel.fromJson(data);
      case 'reservationComplete':
        return ReservationDataModel.fromJson(data);
      case 'reservationCanceled':
        return ReservationDataModel.fromJson(data);
      case 'reservationUrgent':
        return ReservationDataModel.fromJson(data);
      default:
        throw Exception('Unknown push message type: ${data['type']}');
    }
  }
}
