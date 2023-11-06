import 'package:jari_bean/cafe/model/table_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'table_query_model.g.dart';

@JsonSerializable()
class TableQueryModel {
  @JsonKey(name: 'startTime', toJson: dateTimeToQueryParam)
  final DateTime startTime;
  @JsonKey(name: 'endTime', toJson: dateTimeToQueryParam)
  final DateTime endTime;
  @JsonKey(name: 'peopleNumber')
  final int headCount;
  @JsonKey(name: 'tableOptions', toJson: tableOptionListToQueryParams)
  final List<TableType> tableOptionList;

  TableQueryModel({
    required this.startTime,
    required this.endTime,
    required this.headCount,
    required this.tableOptionList,
  });

  TableQueryModel copyWith({
    DateTime? startTime,
    DateTime? endTime,
    int? headCount,
    List<TableType>? tableOptionList,
  }) {
    return TableQueryModel(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      headCount: headCount ?? this.headCount,
      tableOptionList: tableOptionList ?? this.tableOptionList,
    );
  }

  static String tableOptionListToQueryParams(List<TableType> tableOptionList) {
    if (tableOptionList.isEmpty) return '';
    return tableOptionList.map((e) => tableTypeEncode[e]).join(',');
  }

  static dateTimeToQueryParam(DateTime dateTime) {
    return dateTime.toIso8601String().split('.')[0];
  }

  Map<String, dynamic> toJson() => _$TableQueryModelToJson(this);
}
