import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/common/models/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';

part 'history_model.g.dart';

abstract class IHistoryModelBase implements IModelWithId {
  @override
  final String id;
  final int headCount;
  final DateTime startTime;
  final CafeDescriptionModel model;

  IHistoryModelBase({
    required this.id,
    required this.headCount,
    required this.startTime,
    required this.model,
  });
}

@JsonSerializable()
class MatchingModel implements IHistoryModelBase {
  @override
  final String id;
  @override
  @JsonKey(name: 'seating')
  final int headCount;
  @override
  @JsonKey(name: 'startTime')
  final DateTime startTime;
  @override
  @JsonKey(name: 'cafeSummaryDto')
  final CafeDescriptionModel model;
  MatchingModel({
    required this.id,
    required this.headCount,
    required this.startTime,
    required this.model,
  });

  factory MatchingModel.fromJson(Map<String, dynamic> json) =>
      _$MatchingModelFromJson(json);
}

@JsonSerializable()
class ReservationModel implements IHistoryModelBase {
  @override
  @JsonKey(name: 'reserveId')
  final String id;
  @override
  @JsonKey(name: 'matchingSeating')
  final int headCount;
  @override
  @JsonKey(name: 'reserveStartTime')
  final DateTime startTime;
  @JsonKey(name: 'reserveEndTime')
  final DateTime endTime;
  @override
  @JsonKey(name: 'cafeSummaryDto')
  final CafeDescriptionModel model;

  ReservationModel({
    required this.id,
    required this.headCount,
    required this.startTime,
    required this.model,
    required this.endTime,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);
}

class HistoryBundleByDateModel {
  final DateTime date;
  final List<IHistoryModelBase> models;

  HistoryBundleByDateModel({
    required this.date,
    required this.models,
  });
}
