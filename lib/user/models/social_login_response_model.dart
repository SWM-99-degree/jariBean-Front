import 'package:json_annotation/json_annotation.dart';

part 'social_login_response_model.g.dart';

abstract class SocialLoginResponseModelBase {}

class SocialLoginResponseModelLoading extends SocialLoginResponseModelBase {}

@JsonSerializable()
class SocialLoginResponseModel extends SocialLoginResponseModelBase {
  final String code;
  final String type;

  SocialLoginResponseModel({
    required this.code,
    required this.type,
  });

  factory SocialLoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SocialLoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SocialLoginResponseModelToJson(this);
}

class SocialLoginResponseModelError extends SocialLoginResponseModelBase {
  final Object error;
  final String errorDescription;

  SocialLoginResponseModelError(this.error, this.errorDescription);
}
