// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationDetailModel _$ReservationDetailModelFromJson(
        Map<String, dynamic> json) =>
    ReservationDetailModel(
      reservedId: json['reserveId'] as String,
      reservedTime: DateTime.parse(json['reserveTime'] as String),
      reservedNumber: json['reserveNumber'] as String,
      cafeDescriptionModel: CafeDescriptionModel.fromJson(
          json['cafeSummaryDto'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ReservationDetailModelToJson(
        ReservationDetailModel instance) =>
    <String, dynamic>{
      'reserveId': instance.reservedId,
      'reserveTime': instance.reservedTime.toIso8601String(),
      'reserveNumber': instance.reservedNumber,
      'cafeSummaryDto': instance.cafeDescriptionModel,
    };
