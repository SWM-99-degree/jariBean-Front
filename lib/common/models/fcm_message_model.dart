import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jari_bean/common/models/model_with_id.dart';
import 'package:jari_bean/common/utils/utils.dart';
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

@JsonSerializable()
class FcmMessageModel implements IModelWithId {
  @override
  final String id;
  final String title;
  final String body;
  final PushMessageType type;
  @JsonKey(toJson: dataToJson)
  final FcmDataModelBase data;
  FcmMessageModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.data,
  });

  /// convert FcmDataModelBase to json
  /// data must be inherited from FcmDataModelBase
  /// given data will execute toJson function from its class
  /// this will be executed when FcmMessageModel is converted to json
  static dataToJson(FcmDataModelBase data) {
    return data.toJson();
  }

  Map<String, dynamic> toJson() => _$FcmMessageModelToJson(this);

  factory FcmMessageModel.fromFcmMessage(RemoteMessage message) {
    return FcmMessageModel(
      id: message.messageId!.replaceAll('%', '!'),
      title: message.notification!.title!,
      body: message.notification!.body!,
      type: Utils.getPushMessageType(message.data['type']),
      data: Utils.getPushMessageData(
        type: message.data['type'],
        data: message.data,
      ),
    );
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
