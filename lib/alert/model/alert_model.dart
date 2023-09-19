import 'package:jari_bean/common/models/fcm_message_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alert_model.g.dart';

@JsonSerializable()
class AlertModel extends FcmMessageModel {
  @JsonKey(fromJson: dateTimeFromJson, toJson: dateTimeToJson)
  final DateTime receivedAt;
  @JsonKey(
    defaultValue: false,
    fromJson: boolFromInt,
    toJson: boolToInt,
  )
  bool isRead;

  AlertModel({
    required this.receivedAt,
    required this.isRead,
    required String id,
    required String title,
    required String body,
    required PushMessageType type,
    required FcmDataModelBase data,
  }) : super(
          id: id,
          title: title,
          body: body,
          type: type,
          data: data,
        );

  factory AlertModel.fromFcmMessage(FcmMessageModel message) => AlertModel(
        receivedAt: DateTime.now(),
        isRead: false,
        id: message.id,
        title: message.title,
        body: message.body,
        type: message.type,
        data: message.data,
      );

  @override
  Map<String, dynamic> toJson() => _$AlertModelToJson(this);

  Map<String, dynamic> toDB() {
    final alertJson = toJson();
    alertJson.remove('data');
    return alertJson;
  }

  factory AlertModel.fromJson(Map<String, dynamic> json) =>
      _$AlertModelFromJson(json);

  factory AlertModel.fromDB(Map<String, dynamic> json) {
    // duplicate json to prevent modifying original json
    final alertJson = Map<String, dynamic>.from(json);
    alertJson.addEntries(
      [
        MapEntry('data', {'detailedBody': ''})
      ],
    );
    return AlertModel.fromJson(alertJson);
  }

  replaceData(FcmDataModelBase nextData) {
    return AlertModel(
      receivedAt: receivedAt,
      isRead: isRead,
      id: id,
      title: title,
      body: body,
      type: type,
      data: nextData,
    );
  }

  static dateTimeToJson(DateTime dateTime) => dateTime.toIso8601String();

  static DateTime dateTimeFromJson(String dateTime) =>
      DateTime.parse(dateTime).toLocal();

  static int boolToInt(bool value) => value ? 1 : 0;

  static bool boolFromInt(int value) => value == 1;
}
