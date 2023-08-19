// ignore_for_file: constant_identifier_names

import 'package:jari_bean/common/models/location_model.dart';

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

class SearchQueryModel {
  final String searchText;
  final String? serviceAreaId;
  final LocationModel location;
  final DateTime startTime;
  final DateTime endTime;
  final int headCount;
  final List<TableType> tableOptionList;

  SearchQueryModel({
    required this.searchText,
    required this.serviceAreaId,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.headCount,
    required this.tableOptionList,
  });

  SearchQueryModel copyWith({
    String? searchText,
    String? serviceAreaId,
    LocationModel? location,
    DateTime? startTime,
    DateTime? endTime,
    int? headCount,
    List<TableType>? tableOptionList,
  }) {
    return SearchQueryModel(
      searchText: searchText ?? this.searchText,
      serviceAreaId: serviceAreaId ?? this.serviceAreaId,
      location: location ?? this.location,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      headCount: headCount ?? this.headCount,
      tableOptionList: tableOptionList ?? this.tableOptionList,
    );
  }
}
