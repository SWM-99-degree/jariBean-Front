import 'package:jari_bean/common/models/location_model.dart';

class MatchingBodyModel {
  final int headCount;
  final LocationModel location;

  MatchingBodyModel({
    required this.headCount,
    required this.location,
  });

  MatchingBodyModel copyWith({
    int? headCount,
    LocationModel? location,
  }) {
    return MatchingBodyModel(
      headCount: headCount ?? this.headCount,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'peopleNumber': '$headCount',
        'latitude': '${location.latitude}',
        'longitude': '${location.longitude}',
      };
}
