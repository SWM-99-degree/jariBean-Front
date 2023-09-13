import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/alert/provider/alert_provider.dart';
import 'package:jari_bean/common/models/fcm_message_model.dart';
import 'package:jari_bean/common/notification/notification.dart';

final fcmTokenProvider =
    StateNotifierProvider<FcmTokenStateNotifier, String>((ref) {
  return FcmTokenStateNotifier();
});

class FcmTokenStateNotifier extends StateNotifier<String> {
  FcmTokenStateNotifier() : super('') {
    getToken();
  }

  Future<void> getToken() async {
    final messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    state = token!;
  }


}

Future<void> fcmTokenRefreshHandler(String token) async {
  print('Handling a token refresh $token');
}

@pragma('vm:entry-point')
Future<void> fcmMessageHandler(
  RemoteMessage message,
  ProviderContainer container,
) async {
  print('Handling a message ${message.messageId}, ${message.data['title']}');
  final receivedNotification = FcmMessageModel.fromFcmMessage(message);
  container.read(alertProvider.notifier).addAlertFromFcmMessage(
        receivedNotification,
      );
  if (Platform.isIOS) return;
  final notification =
      container.read(notificationProvider.notifier);
  await notification.showFromFcmMessage(message: receivedNotification);
}

@pragma('vm:entry-point')
fcmOnOpenedAppHandler({
  required RemoteMessage message,
  required AlertProvider alertProvider,
  required GoRouter goRouter,
}) async {
  print('message opened by : ${message.messageId}, ${message.data}');
  final receivedNotification = FcmMessageModel.fromFcmMessage(message);
  alertProvider.addAlertFromFcmMessage(
    receivedNotification,
  );
  goRouter.push('/alert/${receivedNotification.id}');
}

final launchedByFCMProvider = StateProvider<RemoteMessage?>((ref) => null);
