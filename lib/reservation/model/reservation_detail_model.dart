import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_detail_model.g.dart';

@JsonSerializable()
class ReservationDetailModel {
  @JsonKey(
    name: 'reserveId',
  )
  final String reservedId;
  @JsonKey(
    name: 'reserveTime',
  )
  final DateTime reservedTime;
  @JsonKey(
    name: 'reserveNumber',
  )
  final String reservedNumber;
  @JsonKey(
    name: 'cafeSummaryDto',
  )
  final CafeDescriptionModel cafeDescriptionModel;

  ReservationDetailModel({
    required this.reservedId,
    required this.reservedTime,
    required this.reservedNumber,
    required this.cafeDescriptionModel,
  });

  factory ReservationDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationDetailModelFromJson(json);
}
