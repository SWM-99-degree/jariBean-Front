// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvaliableTimeRange _$AvaliableTimeRangeFromJson(Map<String, dynamic> json) =>
    AvaliableTimeRange(
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
    );

Map<String, dynamic> _$AvaliableTimeRangeToJson(AvaliableTimeRange instance) =>
    <String, dynamic>{
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
    };

TableDetailModel _$TableDetailModelFromJson(Map<String, dynamic> json) =>
    TableDetailModel(
      tableModel: TableDescriptionModel.fromJson(
          json['tableDetailDto'] as Map<String, dynamic>),
      avaliableTimeRangeList: (json['availableTimeList'] as List<dynamic>)
          .map((e) => AvaliableTimeRange.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TableDetailModelToJson(TableDetailModel instance) =>
    <String, dynamic>{
      'tableDetailDto': instance.tableModel,
      'availableTimeList': instance.avaliableTimeRangeList,
    };

TableDescriptionModel _$TableDescriptionModelFromJson(
        Map<String, dynamic> json) =>
    TableDescriptionModel(
      id: json['id'] as String,
      name: json['description'] as String,
      imgUrl: json['image'] as String,
      maxHeadcount: json['seating'] as int,
      tableOptionsList: TableDescriptionModel.tableTypeFromJson(
          json['tableOptionList'] as List),
    );

Map<String, dynamic> _$TableDescriptionModelToJson(
        TableDescriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.name,
      'image': instance.imgUrl,
      'seating': instance.maxHeadcount,
      'tableOptionList':
          TableDescriptionModel.tableTypeToJson(instance.tableOptionsList),
    };
