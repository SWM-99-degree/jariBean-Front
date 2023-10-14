import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jari_bean/common/models/location_model.dart';

final locationProvider =
    StateNotifierProvider<LocationStateNotifier, LocationModelBase>((ref) {
  return LocationStateNotifier();
});

class LocationStateNotifier extends StateNotifier<LocationModelBase> {
  LocationStateNotifier() : super(LocationModelLoading());

  Future<void> getLocation() async {
    try {
      await requestGeolocationPermission();
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      state = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      print(e);
      state = LocationModelError(
        message: '위치를 가져오던 중 오류가 발생했습니다.',
      );
    }
  }

  requestGeolocationPermission() async {
    final geolocationStatus = await Geolocator.checkPermission();
    if (geolocationStatus == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }
}
