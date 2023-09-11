import 'package:jari_bean/common/models/fcm_message_model.dart';

class AlertModel extends FcmMessageModel {
  final DateTime receivedAt;
  final String? detailedBody;
  bool isRead;

  AlertModel({
    required this.receivedAt,
    required this.detailedBody,
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
        detailedBody: message.data.detailedBody,
        isRead: false,
        id: message.id,
        title: message.title,
        body: message.body,
        type: message.type,
        data: message.data,
      );
}
