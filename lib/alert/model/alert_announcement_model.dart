import 'package:jari_bean/common/models/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'alert_announcement_model.g.dart';

abstract class AlertAnnouncementModelBase {}

class AlertAnnouncementLoadingModel extends AlertAnnouncementModelBase {}

class AlertAnnouncementErrorModel extends AlertAnnouncementModelBase {
  final String message;
  AlertAnnouncementErrorModel({
    this.message = '알림을 불러오는데 실패했습니다.',
  });
}

@JsonSerializable()
class AlertAnnouncementModel extends AlertAnnouncementModelBase
    implements IModelWithId {
  @override
  String get id => title;
  final String title;
  final String content;
  final DateTime createdAt;

  AlertAnnouncementModel({
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory AlertAnnouncementModel.fromJson(Map<String, dynamic> json) =>
      _$AlertAnnouncementModelFromJson(json);
}
