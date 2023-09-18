import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jari_bean/common/models/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fcm_message_model.g.dart';

enum PushMessageType {
  matchingSuccess,
  matchingFail,
  matchingCancel,
  matchingUrgent,
  announcement,
  ads,
  reservationInfo,
  reservationComplete,
  reservationCanceled,
  reservationUrgent,
}

class FcmMessageModel implements IModelWithId {
  @override
  final String id;
  final String title;
  final String body;
  final PushMessageType type;
  final FcmDataModelBase data;
  FcmMessageModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
  });

  factory FcmMessageModel.fromFcmMessage(RemoteMessage message) =>
      FcmMessageModel(
        id: message.messageId!.replaceAll('%', '!'),
        title: message.notification!.title!,
        body: message.notification!.body!,
        type: _getPushMessageType(message.data['type']),
        data: _getPushMessageData(message.data),
      );

  static PushMessageType _getPushMessageType(String type) {
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

  static FcmDataModelBase _getPushMessageData(Map<String, dynamic> data) {
    switch (data['type']) {
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

@JsonSerializable()
class FcmDataModelBase {
  final String? detailedBody;

  FcmDataModelBase({
    this.detailedBody,
  });

  factory FcmDataModelBase.fromJson(Map<String, dynamic> json) =>
      _$FcmDataModelBaseFromJson(json);

  Map<String, dynamic> toJson() => _$FcmDataModelBaseToJson(this);
}

@JsonSerializable()
class MatchingBaseDataModel extends FcmDataModelBase {
  final String matchingId;

  MatchingBaseDataModel({
    required this.matchingId,
  });

  factory MatchingBaseDataModel.fromJson(Map<String, dynamic> json) =>
      _$MatchingBaseDataModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MatchingBaseDataModelToJson(this);
}

@JsonSerializable()
class MatchingSuccessModel extends MatchingBaseDataModel {
  final String cafeId;

  MatchingSuccessModel({
    required String matchingId,
    required this.cafeId,
  }) : super(
          matchingId: matchingId,
        );

  factory MatchingSuccessModel.fromJson(Map<String, dynamic> json) =>
      _$MatchingSuccessModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MatchingSuccessModelToJson(this);
}

@JsonSerializable()
class MatchingFailModel extends MatchingBaseDataModel {
  MatchingFailModel({
    required String matchingId,
  }) : super(
          matchingId: matchingId,
        );

  factory MatchingFailModel.fromJson(Map<String, dynamic> json) =>
      _$MatchingFailModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MatchingFailModelToJson(this);
}

@JsonSerializable()
class MatchingCancelModel extends MatchingBaseDataModel {
  MatchingCancelModel({
    required String matchingId,
  }) : super(
          matchingId: matchingId,
        );

  factory MatchingCancelModel.fromJson(Map<String, dynamic> json) =>
      _$MatchingCancelModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MatchingCancelModelToJson(this);
}

@JsonSerializable()
class MatchingUrgentModel extends MatchingBaseDataModel {
  MatchingUrgentModel({
    required String matchingId,
  }) : super(
          matchingId: matchingId,
        );

  factory MatchingUrgentModel.fromJson(Map<String, dynamic> json) =>
      _$MatchingUrgentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MatchingUrgentModelToJson(this);
}

@JsonSerializable()
class AnnouncementDataModel extends FcmDataModelBase {
  final String announcementId;
  final String announcementBody;

  AnnouncementDataModel({
    required this.announcementId,
    required this.announcementBody,
  }) : super(
          detailedBody: announcementBody,
        );

  factory AnnouncementDataModel.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementDataModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AnnouncementDataModelToJson(this);
}

@JsonSerializable()
class AdsDataModel extends FcmDataModelBase {
  final String adsId;
  final String adsBody;

  AdsDataModel({
    required this.adsId,
    required this.adsBody,
  }) : super(
          detailedBody: adsBody,
        );

  factory AdsDataModel.fromJson(Map<String, dynamic> json) =>
      _$AdsDataModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AdsDataModelToJson(this);
}

@JsonSerializable()
class ReservationDataModel extends FcmDataModelBase {
  final String reservationId;

  ReservationDataModel({
    required this.reservationId,
  });

  factory ReservationDataModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationDataModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ReservationDataModelToJson(this);
}
