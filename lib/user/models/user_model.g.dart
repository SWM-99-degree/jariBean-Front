// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      socialLoginType: $enumDecodeNullable(
          _$SocialLoginTypeEnumMap, json['socialLoginType']),
      imgUrl: json['imageUrl'] as String,
      description: json['description'] as String?,
      role: $enumDecode(_$RoleEnumMap, json['role']),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'nickname': instance.nickname,
      'socialLoginType': _$SocialLoginTypeEnumMap[instance.socialLoginType],
      'imageUrl': instance.imgUrl,
      'description': instance.description,
      'role': _$RoleEnumMap[instance.role]!,
    };

const _$SocialLoginTypeEnumMap = {
  SocialLoginType.kakao: 'kakao',
  SocialLoginType.google: 'google',
  SocialLoginType.apple: 'apple',
};

const _$RoleEnumMap = {
  Role.UNREGISTERED: 'UNREGISTERED',
  Role.CUSTOMER: 'CUSTOMER',
  Role.MANAGER: 'MANAGER',
};
