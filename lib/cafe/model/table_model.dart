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
class TableDetailModel {
  @JsonKey(name: 'tableDetailDto')
  final TableDescriptionModel tableModel;
  @JsonKey(name: 'availableTimeList')
  final List<AvaliableTimeRange> avaliableTimeRangeList;

  TableDetailModel({
    required this.tableModel,
    required this.avaliableTimeRangeList,
  });

  factory TableDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TableDetailModelFromJson(json);
}

@JsonSerializable()
class TableDescriptionModel implements IModelWithId {
  @override
  final String id;
  @JsonKey(name: 'description')
  final String name;
  @JsonKey(name: 'image')
  final String imgUrl;
  @JsonKey(name: 'seating')
  final int maxHeadcount;
  final List<TableType> tableOptionsList;

  TableDescriptionModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.maxHeadcount,
    required this.tableOptionsList,
  });

  factory TableDescriptionModel.fromJson(Map<String, dynamic> json) =>
      _$TableDescriptionModelFromJson(json);
}
