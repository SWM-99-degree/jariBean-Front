import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/model/alert_model.dart';
import 'package:jari_bean/common/models/fcm_message_model.dart';

final alertProvider = StateNotifierProvider<AlertProvider, List<AlertModel>>(
  (ref) => AlertProvider(),
);

class AlertProvider extends StateNotifier<List<AlertModel>> {
  AlertProvider()
      : super(
          [
            AlertModel(
              id: 'test-id',
              title: '자리빈에 오신것을 환영합니다',
              isRead: false,
              body: '메뚜기 월드에 오신걸 환영합니다~',
              type: PushMessageType.announcement,
              receivedAt: DateTime.now(),
              detailedBody: 'detailedBody',
              data: FcmDataModelBase(),
            ),
          ],
        );

  AlertModel getAlertById(String id) {
    return state.firstWhere((element) => element.id == id);
  }

  void addAlertFromFcmMessage(FcmMessageModel message) {
    if (state.any((element) => element.id == message.id)) {
      return;
    }
    state = [
      AlertModel.fromFcmMessage(message),
      ...state,
    ];
  }

  void markAsRead(String id) {
    final alert = getAlertById(id);
    alert.isRead = true;
    state = [...state];
  }
}
