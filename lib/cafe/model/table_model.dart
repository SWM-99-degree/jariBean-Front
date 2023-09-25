// ignore_for_file: constant_identifier_names

import 'package:jari_bean/common/models/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table_model.g.dart';

enum TableType {
  HIGH,
  RECTANGLE,
  PLUG,
  BACKREST,
}

final tableTypeButtonName = {
  TableType.HIGH: '높은의자',
  TableType.RECTANGLE: '직사각형',
  TableType.PLUG: '콘센트',
  TableType.BACKREST: '등받이',
};

@JsonSerializable()
class AvaliableTimeRange {
  final DateTime startTime;
  final DateTime endTime;

  AvaliableTimeRange({
    required this.startTime,
    required this.endTime,
  });

  factory AvaliableTimeRange.fromJson(Map<String, dynamic> json) =>
      _$AvaliableTimeRangeFromJson(json);
}

@JsonSerializable()
class TableModel implements IModelWithId {
  @JsonKey(name: 'tableId')
  @override
  final String id;
  @JsonKey(name: 'tableName')
  final String name;
  @JsonKey(name: 'tableSeating')
  final int maxHeadcount;
  @JsonKey(name: 'tableImageUrl')
  final String imgUrl;
  final List<TableType> tableOptionsList;
  @JsonKey(name: 'availableTimeList')
  final List<AvaliableTimeRange> avaliableTimeRangeList;

  TableModel({
    required this.id,
    required this.name,
    required this.maxHeadcount,
    required this.imgUrl,
    required this.tableOptionsList,
    required this.avaliableTimeRangeList,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) =>
      _$TableModelFromJson(json);
}
