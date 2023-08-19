import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        id: '234234',
        name: '고려대',
        imgUrl: 'https://picsum.photos/250?id=0',
      ),
      ServiceAreaModel(
        id: '234234',
        name: '고려대',
        imgUrl: 'https://picsum.photos/250?id=1',
      ),
      ServiceAreaModel(
        id: '234234',
        name: '고려대',
        imgUrl: 'https://picsum.photos/250?id=2',
      ),
      ServiceAreaModel(
        id: '234234',
        name: '고려대',
        imgUrl: 'https://picsum.photos/250?id=3',
      ),
      ServiceAreaModel(
        id: '234234',
        name: '고려대',
        imgUrl: 'https://picsum.photos/250?id=4',
      ),
      ServiceAreaModel(
        id: '234234',
        name: '고려대',
        imgUrl: 'https://picsum.photos/250?id=5',
      ),
    ];
  }

  ServiceAreaModel? getServiceAreaById(String? id) {
    if(id == null) return null;
    return state.firstWhere((element) => element.id == id);
  }
}
