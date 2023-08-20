enum Type {
  alert,
  data,
}

class FcmMessageModel<T extends IBaseFcmMessageDataModel> {
  final String messageId;
  final T data;
  final Type type;
  FcmMessageModel({
    required this.messageId,
    required this.data,
    required this.type,
  });
}

abstract class IBaseFcmMessageDataModel {}

class FcmMessageDataAlertModel extends IBaseFcmMessageDataModel {
  final String title;
  final String body;
  final String clickAction;
  FcmMessageDataAlertModel({
    required this.title,
    required this.body,
    required this.clickAction,
  });
}
