import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cafe_detail_model.g.dart';

@JsonSerializable()
class CafeDetailModel {
  @JsonKey(name: 'cafeSummaryDto')
  final CafeDescriptionModel cafeModel;
  final DateTime openingHour;
  final DateTime closingHour;
  final String description;
  final String instagram;
  final String phoneNumber;
  @JsonKey(name: 'image')
  final String imgUrl;

  CafeDetailModel({
    required this.cafeModel,
    required this.openingHour,
    required this.closingHour,
    required this.description,
    required this.instagram,
    required this.phoneNumber,
    required this.imgUrl,
  });

  factory CafeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$CafeDetailModelFromJson(json);
}
