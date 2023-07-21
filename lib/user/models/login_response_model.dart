import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart';

abstract class LoginResponseModelBase{}

class LoginResponseModelLoading extends LoginResponseModelBase{}

@JsonSerializable()
class LoginResponseModel extends LoginResponseModelBase{
  final String accessToken;
  final String refreshToken;

  LoginResponseModel(this.accessToken, this.refreshToken);

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);
}

class LoginResponseModelError extends LoginResponseModelBase{
  final Object error;
  final String errorDescription;

  LoginResponseModelError(this.error, this.errorDescription);
}