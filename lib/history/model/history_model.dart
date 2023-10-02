import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history_model.g.dart';

@JsonSerializable()
class HistoryBaseModel {
  final String id;
  final int headCount;
  final DateTime startTime;
  @JsonKey(name: 'cafeSummaryDto')
  final CafeDescriptionModel model;

  HistoryBaseModel({
    required this.id,
    required this.headCount,
    required this.startTime,
    required this.model,
  });

  factory HistoryBaseModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryBaseModelFromJson(json);
}

@JsonSerializable()
class MatchingModel extends HistoryBaseModel {
  MatchingModel({
    required super.id,
    required super.headCount,
    required super.startTime,
    required super.model,
  }) : super();

  factory MatchingModel.fromJson(Map<String, dynamic> json) =>
      _$MatchingModelFromJson(json);
}

@JsonSerializable()
class ReservationModel extends HistoryBaseModel {
  final DateTime endTime;

  ReservationModel({
    required super.id,
    required super.headCount,
    required super.startTime,
    required super.model,
    required this.endTime,
  }) : super();

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);
}

class HistoryBundleByDateModel {
  final DateTime date;
  final List<HistoryBaseModel> models;

  HistoryBundleByDateModel({
    required this.date,
    required this.models,
  });
}
