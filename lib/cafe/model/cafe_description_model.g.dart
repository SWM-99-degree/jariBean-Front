// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cafe_description_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CafeDescriptionModel _$CafeDescriptionModelFromJson(
        Map<String, dynamic> json) =>
    CafeDescriptionModel(
      id: json['id'] as String,
      title: json['name'] as String,
      imgUrl: json['imageUrl'] as String,
      cafeAddress: json['address'] as String,
    );

Map<String, dynamic> _$CafeDescriptionModelToJson(
        CafeDescriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.title,
      'imageUrl': instance.imgUrl,
      'address': instance.cafeAddress,
    };
