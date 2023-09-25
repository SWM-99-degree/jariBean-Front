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

TableModel _$TableModelFromJson(Map<String, dynamic> json) => TableModel(
      id: json['tableId'] as String,
      name: json['tableName'] as String,
      maxHeadcount: json['tableSeating'] as int,
      imgUrl: json['tableImageUrl'] as String,
      tableOptionsList: (json['tableOptionsList'] as List<dynamic>)
          .map((e) => $enumDecode(_$TableTypeEnumMap, e))
          .toList(),
      avaliableTimeRangeList: (json['availableTimeList'] as List<dynamic>)
          .map((e) => AvaliableTimeRange.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TableModelToJson(TableModel instance) =>
    <String, dynamic>{
      'tableId': instance.id,
      'tableName': instance.name,
      'tableSeating': instance.maxHeadcount,
      'tableImageUrl': instance.imgUrl,
      'tableOptionsList':
          instance.tableOptionsList.map((e) => _$TableTypeEnumMap[e]!).toList(),
      'availableTimeList': instance.avaliableTimeRangeList,
    };

const _$TableTypeEnumMap = {
  TableType.HIGH: 'HIGH',
  TableType.RECTANGLE: 'RECTANGLE',
  TableType.PLUG: 'PLUG',
  TableType.BACKREST: 'BACKREST',
};
