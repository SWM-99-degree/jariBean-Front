import 'package:jari_bean/cafe/model/cafe_detail_model.dart';
import 'package:jari_bean/cafe/model/table_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cafe_total_information_model.g.dart';

@JsonSerializable()
class CafeTotalInformationModel {
  @JsonKey(name: 'cafeDetailDto')
  final CafeDetailModel cafeDetailModel;
  @JsonKey(name: 'tableReserveResDtoList')
  final List<TableDetailModel> tableDetailModelList;

  CafeTotalInformationModel({
    required this.cafeDetailModel,
    required this.tableDetailModelList,
  });

  factory CafeTotalInformationModel.fromJson(Map<String, dynamic> json) =>
      _$CafeTotalInformationModelFromJson(json);
}
