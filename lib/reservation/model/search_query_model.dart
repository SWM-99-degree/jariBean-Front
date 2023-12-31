import 'package:jari_bean/cafe/model/table_model.dart';
import 'package:jari_bean/common/models/location_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_query_model.g.dart';

@JsonSerializable()
class SearchQueryModel {
  @JsonKey(name: 'searchingWord')
  final String searchText;
  final String? serviceAreaId;
  @JsonKey(name: 'location', toJson: locationModelToJson)
  final LocationModel? location;
  @JsonKey(name: 'reserveStartTime')
  final DateTime startTime;
  @JsonKey(name: 'reserveEndTime')
  final DateTime endTime;
  @JsonKey(name: 'peopleNumber')
  final int headCount;
  @JsonKey(
    name: 'tableOptionList',
    toJson: TableDescriptionModel.tableTypeToJson,
  )
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

  SearchQueryModel copyWithLocation(LocationModel? location) {
    return SearchQueryModel(
      searchText: searchText,
      serviceAreaId: serviceAreaId,
      location: location,
      startTime: startTime,
      endTime: endTime,
      headCount: headCount,
      tableOptionList: tableOptionList,
    );
  }

  SearchQueryModel copyWithServiceAreaId(String? serviceAreaId) {
    return SearchQueryModel(
      searchText: searchText,
      serviceAreaId: serviceAreaId,
      location: location,
      startTime: startTime,
      endTime: endTime,
      headCount: headCount,
      tableOptionList: tableOptionList,
    );
  }

  Map<String, dynamic> toJson() => _$SearchQueryModelToJson(this);

  static Map<String, dynamic>? locationModelToJson(LocationModel? location) {
    if (location == null) {
      return null;
    }
    return {
      'latitude': location.latitude,
      'longitude': location.longitude,
    };
  }
}
