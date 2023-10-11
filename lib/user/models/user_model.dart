// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum SocialLoginType { kakao, google, apple }

enum Role { UNREGISTERED, CUSTOMER, MANAGER }

abstract class UserModelBase {}

class UserModelError extends UserModelBase {
  final Object error;
  final String message;
  UserModelError(this.error, this.message);
}

class UserModelLoading extends UserModelBase {}

@JsonSerializable()
class UserModel extends UserModelBase {
  final String id;
  final String nickname;
  @JsonKey(name: 'socialId')
  final SocialLoginType? socialLoginType;
  @JsonKey(name: 'imageUrl')
  final String imgUrl;
  final String? description;
  final Role role;
  UserModel({
    required this.id,
    required this.nickname,
    required this.socialLoginType,
    required this.imgUrl,
    required this.description,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
