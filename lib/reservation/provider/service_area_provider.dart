import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/models/location_model.dart';
import 'package:jari_bean/reservation/model/service_area_model.dart';

final serviceAreaProvider =
    StateNotifierProvider<ServiceAreaStateNotifier, List<ServiceAreaModel>>(
  (ref) {
    return ServiceAreaStateNotifier();
  },
);

class ServiceAreaStateNotifier extends StateNotifier<List<ServiceAreaModel>> {
  ServiceAreaStateNotifier() : super([]) {
    init();
  }

  void init() {
    state = [
      ServiceAreaModel(
        id: '고려대',
        name: '고려대',
        imgUrl: 'https://img.jari-bean.com/koreauniversity.jpeg',
        location: LocationModel(
          latitude: 37.586830986,
          longitude: 127.025999896,
        ),
      ),
    ];
  }

  ServiceAreaModel? getServiceAreaById(String? id) {
    if (id == null) return null;
    return state.firstWhere((element) => element.id == id);
  }
}
