import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/model/alert_model.dart';

final alertProvider = StateNotifierProvider<AlertProvider, List<AlertModel>>(
  (ref) => AlertProvider(),
);

class AlertProvider extends StateNotifier<List<AlertModel>> {
  AlertProvider()
      : super(
          [
            AlertModel(
                id: 'test-id',
                title: 'test',
                description: 'this is a test',
                buttonTitle: '테스트입니다',
                image: 'https://picsum.photos/200/300'),
          ],
        );

  AlertModel getAlertById(String id) {
    return state.firstWhere((element) => element.id == id);
  }
}
