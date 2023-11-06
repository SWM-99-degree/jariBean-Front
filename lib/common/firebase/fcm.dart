import 'dart:io';
import 'package:dio/dio.dart' hide Headers;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/alert/provider/alert_provider.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/dio/dio.dart';
import 'package:jari_bean/common/models/fcm_message_model.dart';
import 'package:jari_bean/common/notification/notification.dart';

final fcmTokenProvider =
    StateNotifierProvider<FcmTokenStateNotifier, String>((ref) {
  final dio = ref.watch(dioProvider);
  return FcmTokenStateNotifier(
    dio,
  );
});

class FcmTokenStateNotifier extends StateNotifier<String> {
  final Dio dio;
  FcmTokenStateNotifier(
    this.dio,
  ) : super('') {
    getToken();
    uploadToken();
  }

  Future<void> getToken() async {
    final messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    state = token!;
  }

  Future<void> deleteToken() async {
    final messaging = FirebaseMessaging.instance;
    await messaging.deleteToken();
    state = '';
  }

  Future<void> updateToken(String token) async {
    state = token;
    uploadToken();
  }

  Future<void> uploadToken() async {
    final token = state;
    await dio.put(
      '$ip/api/fcm/token',
      data: {
        'firebaseToken': token,
      },
      options: Options(
        headers: {
          'accessToken': 'true',
        },
      ),
    );
  }
}

Future<void> fcmTokenRefreshHandler(
  String token,
  FcmTokenStateNotifier notifier,
) async {
  print('Handling a token refresh $token');
  notifier.updateToken(token);
}

@pragma('vm:entry-point')
Future<void> fcmMessageHandler(
  RemoteMessage message,
  ProviderContainer container,
) async {
  await Firebase.initializeApp();
  print('Handling a message ${message.messageId}, ${message.data['title']}');
  final receivedNotification = FcmMessageModel.fromFcmMessage(message);
  container.read(alertProvider.notifier).addAlertFromFcmMessage(
        receivedNotification,
      );
  if (Platform.isIOS) return;
  final notification = container.read(notificationProvider.notifier);
  await notification.showFromFcmMessage(message: receivedNotification);
}

@pragma('vm:entry-point')
fcmOnOpenedAppHandler({
  required RemoteMessage message,
  required AlertStateNotifier alertProvider,
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
