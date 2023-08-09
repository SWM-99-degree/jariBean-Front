// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      nickname: json['nickname'] as String,
      socialLoginType:
          $enumDecode(_$SocialLoginTypeEnumMap, json['socialLoginType']),
      imgUrl: json['imgUrl'] as String,
      isRegistered: json['isRegistered'] as bool?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'nickname': instance.nickname,
      'socialLoginType': _$SocialLoginTypeEnumMap[instance.socialLoginType]!,
      'imgUrl': instance.imgUrl,
      'isRegistered': instance.isRegistered,
    };

const _$SocialLoginTypeEnumMap = {
  SocialLoginType.kakao: 'kakao',
  SocialLoginType.google: 'google',
  SocialLoginType.apple: 'apple',
};
