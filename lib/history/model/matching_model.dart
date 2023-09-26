import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'matching_model.g.dart';

@JsonSerializable()
class MatchingModel {
  @JsonKey(name: 'id')
  final String matchingId;
  @JsonKey(name: 'seating')
  final int matchingHeadCount;
  @JsonKey(name: 'startTime')
  final DateTime matchingStartTime;
  @JsonKey(name: 'cafeSummaryDto')
  final CafeDescriptionModel model;

  MatchingModel({
    required this.matchingId,
    required this.matchingHeadCount,
    required this.matchingStartTime,
    required this.model,
  });

  factory MatchingModel.fromJson(Map<String, dynamic> json) =>
      _$MatchingModelFromJson(json);
}
