import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fcmProvider = Provider<FirebaseMessaging>((ref) {
  final firebaseApp =  Firebase.app();
  final messaging = FirebaseMessaging.instance;
  print('restaert');

  return messaging;
});

final fcmTokenProvider = StateNotifierProvider<FcmTokenStateNotifier, String>((ref) {
  return FcmTokenStateNotifier();
});

class FcmTokenStateNotifier extends StateNotifier<String>{
  FcmTokenStateNotifier() : super('') {
    getToken();
  }

  Future<void> getToken() async {
    final messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    state = token!;
  }
}

Future fcmBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  print(
      'And the MESSAGE was : ${message.notification!.title} + ${message.notification!.body}');
}

Future fcmForegroundHandler(
    RemoteMessage message,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    AndroidNotificationChannel? channel) async {
  print('[FCM - Foreground] MESSAGE : ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification!.title} + ${message.notification!.body}');
  }
}

Future<void> setupInteractedMessage(FirebaseMessaging fbMsg) async {
  RemoteMessage? initialMessage = await fbMsg.getInitialMessage();
  // 종료상태에서 클릭한 푸시 알림 메세지 핸들링
  if (initialMessage != null) clickMessageEvent(initialMessage);
  // 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메세지 스트림을 통해 처리
  FirebaseMessaging.onMessageOpenedApp.listen(clickMessageEvent);
}

void clickMessageEvent(RemoteMessage message) {
  print('message : ${message.notification!.title}');
}
