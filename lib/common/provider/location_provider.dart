import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jari_bean/common/models/location_model.dart';
import 'package:jari_bean/common/repository/geocode_repository.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';

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

  void resetLocation() {
    state = LocationModelLoading();
  }

  requestGeolocationPermission() async {
    final geolocationStatus = await Geolocator.checkPermission();
    if (geolocationStatus == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  }
}

final geocodeProvider =
    StateNotifierProvider.autoDispose<GeocodeStateNotifier, String>(
  (ref) {
    ref.onDispose(() {
      ref.read(searchQueryProvider.notifier).location =
          null; // for reset location in search query
    });
    return GeocodeStateNotifier(
      geocodeRepository: ref.read(geocodeRepositoryProvider),
      locationProvider: ref.read(locationProvider.notifier),
    );
  },
);

class GeocodeStateNotifier extends StateNotifier<String> {
  final GeocodeRepository geocodeRepository;
  final LocationStateNotifier locationProvider;
  GeocodeStateNotifier({
    required this.geocodeRepository,
    required this.locationProvider,
  }) : super(defaultGeocodeString) {
    getGeocode();
  }

  Future<bool> getGeocode() async {
    try {
      if (locationProvider.state is! LocationModel) {
        return false;
      }
      final location = locationProvider.state as LocationModel;
      final geocodeModel = await geocodeRepository.getGeocode(
        location.longitude,
        location.latitude,
        'WGS84',
        'WGS84',
      );
      state = geocodeModel.documents.last.addressName;
      return true;
    } catch (e) {
      print(e);
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          state = errorGeocodeStringNotServiceArea;
          locationProvider.resetLocation();
          return false;
        }
      }
      state = errorGeocodeString;
      return false;
    }
  }

  void setGeocodeFromServiceAreaName(String serviceAreaName) {
    state = serviceAreaName;
  }

  void resetGeocode() {
    state = defaultGeocodeString;
    locationProvider.resetLocation();
  }
}

const String defaultGeocodeString = '현재 위치를 불러올 수 있어요';
const String errorGeocodeString = '오류가 발생했어요';
const String errorGeocodeStringNotServiceArea = '서비스 지역이 아니에요';
