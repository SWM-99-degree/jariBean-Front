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

final tableTypeDecode = {
  'HEIGHT': TableType.HIGH,
  'RECTANGLE': TableType.RECTANGLE,
  'PLUG': TableType.PLUG,
  'BACKREST': TableType.BACKREST,
};

final tableTypeEncode = {
  TableType.HIGH: 'HEIGHT',
  TableType.RECTANGLE: 'RECTANGLE',
  TableType.PLUG: 'PLUG',
  TableType.BACKREST: 'BACKREST',
};

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
  @JsonKey(
    fromJson: tableTypeFromJson,
    toJson: tableTypeToJson,
    name: 'tableOptionList',
  )
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

  static List<TableType> tableTypeFromJson(List<dynamic> json) {
    return json.map((e) {
      final type = tableTypeDecode[e];
      if (type == null) {
        throw Exception(
          'TableType is not defined',
        ); // if there is no type in tableTypeDecode, throw exception
      }
      return type;
    }).toList();
  }

  static List<dynamic> tableTypeToJson(List<TableType> tableTypeList) {
    return tableTypeList.map((e) => tableTypeEncode[e]).toList();
  }
}
