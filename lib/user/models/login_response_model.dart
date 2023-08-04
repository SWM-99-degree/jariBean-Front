import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart';

abstract class LoginResponseModelBase {}

@JsonSerializable()
class LoginResponseModel extends LoginResponseModelBase{
  final String accessToken;
  final String refreshToken;
  LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);
}

class LoginResponseModelError extends LoginResponseModelBase{
  final Object error;
  final String errorDescription;

  LoginResponseModelError(this.error, this.errorDescription);
}

class LoginResponseModelLoading extends LoginResponseModelBase{}