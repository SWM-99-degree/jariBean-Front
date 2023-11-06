import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

abstract class LocationModelBase {}

class LocationModelLoading extends LocationModelBase {}

@JsonSerializable()
class LocationModel extends LocationModelBase {
  final double latitude;
  final double longitude;

  LocationModel({
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}

class LocationModelError extends LocationModelBase {
  final String message;

  LocationModelError({
    required this.message,
  });
}
