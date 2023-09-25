import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_model.g.dart';

@JsonSerializable()
class ReservationModel {
  @JsonKey(name: 'reserveId')
  final String reservationId;
  @JsonKey(name: 'reserveStartTime')
  final DateTime reservationStartTime;
  @JsonKey(name: 'reserveEndTime')
  final DateTime reservationEndTime;
  @JsonKey(name: 'matchingSeating')
  final int reservationHeadCount;
  @JsonKey(name: 'cafeSummaryDto')
  final CafeDescriptionModel model;

  ReservationModel({
    required this.reservationId,
    required this.reservationStartTime,
    required this.reservationEndTime,
    required this.reservationHeadCount,
    required this.model,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);
}
