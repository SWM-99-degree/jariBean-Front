abstract class LocationModelBase {}

class LocationModelLoading extends LocationModelBase {}

class LocationModel extends LocationModelBase {
  final double latitude;
  final double longitude;

  LocationModel({
    required this.latitude,
    required this.longitude,
  });
}

class LocationModelError extends LocationModelBase {
  final String message;

  LocationModelError({
    required this.message,
  });
}
