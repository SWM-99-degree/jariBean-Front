import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum SocialLoginType {
  kakao,
  google,
  apple
}

abstract class UserModelBase {}

class UserModelError extends UserModelBase{
  final String message;
  UserModelError({required this.message});
}

class UserModelLoading extends UserModelBase{}

@JsonSerializable()
class UserModel extends UserModelBase{
  String nickname;
  SocialLoginType socialLoginType;
  String imgUrl;
  UserModel({
    required this.nickname,
    required this.socialLoginType,
    required this.imgUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  
}