// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'matching_status_model.g.dart';

enum MatchingStatus { NORMAL, ENQUEUED, PROCESSING }

@JsonSerializable()
class MatchingStatusModel {
  final MatchingStatus status;
  final String? matchingId;
  final String? cafeId;
  final DateTime? startTime;

  MatchingStatusModel({
    required this.status,
    this.matchingId,
    this.cafeId,
    this.startTime,
  });

  factory MatchingStatusModel.fromJson(Map<String, dynamic> json) =>
      _$MatchingStatusModelFromJson(json);
}
