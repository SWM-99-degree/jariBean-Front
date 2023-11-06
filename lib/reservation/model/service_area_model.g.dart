// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_area_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceAreaModel _$ServiceAreaModelFromJson(Map<String, dynamic> json) =>
    ServiceAreaModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imgUrl: Utils.pathToUrl(json['imgUrl'] as String),
      location:
          LocationModel.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ServiceAreaModelToJson(ServiceAreaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imgUrl': instance.imgUrl,
      'location': instance.location,
    };
