// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cafe_description_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CafeDescriptionModel _$CafeDescriptionModelFromJson(
        Map<String, dynamic> json) =>
    CafeDescriptionModel(
      id: json['cafeId'] as String,
      title: json['cafeName'] as String,
      imgUrl: json['cafeImageUrl'] as String,
      cafeAddress: json['cafeAddress'] as String,
    );

Map<String, dynamic> _$CafeDescriptionModelToJson(
        CafeDescriptionModel instance) =>
    <String, dynamic>{
      'cafeId': instance.id,
      'cafeName': instance.title,
      'cafeImageUrl': instance.imgUrl,
      'cafeAddress': instance.cafeAddress,
    };
