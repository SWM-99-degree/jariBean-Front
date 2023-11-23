import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/models/fcm_message_model.dart';
import 'package:jari_bean/common/provider/go_router_provider.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'jari_bean_alert', // id
  '자리:Bean 알림', // title
  description: '자리:빈의 알림을 전해드리는 채널이에요.', // description
  importance: Importance.max,
);

AndroidInitializationSettings initSettingsAndroid =
    const AndroidInitializationSettings('@mipmap/ic_launcher');

DarwinInitializationSettings initSettingsIOS =
    const DarwinInitializationSettings(
  requestSoundPermission: true,
  requestBadgePermission: true,
  requestAlertPermission: true,
);

InitializationSettings initSettings = InitializationSettings(
  android: initSettingsAndroid,
  iOS: initSettingsIOS,
);

NotificationDetails notificationDetails = NotificationDetails(
  android: AndroidNotificationDetails(
    channel.id,
    channel.name,
    channelDescription: channel.description,
    icon: '@mipmap/ic_launcher',
  ),
  iOS: const DarwinNotificationDetails(),
);

final notificationProvider = StateNotifierProvider<NotificationStateNotifier,
    FlutterLocalNotificationsPlugin>((ref) {
  final goRouter = ref.read(goRouterProvider);
  return NotificationStateNotifier(goRouter: goRouter);
});

class NotificationStateNotifier
    extends StateNotifier<FlutterLocalNotificationsPlugin> {
  int id = 0;
  NotificationAppLaunchDetails? notificationAppLaunchDetails;
  final GoRouter goRouter;
  NotificationStateNotifier({
    required this.goRouter,
  }) : super(FlutterLocalNotificationsPlugin()) {
    init();
  }

  Future<void> init() async {
    await state
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    notificationAppLaunchDetails =
        await state.getNotificationAppLaunchDetails();

    await state.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload == null) return;
        goRouter.go('/alert/${details.payload}');
      },
    );
  }

  Future<NotificationAppLaunchDetails?> getAlert() {
    return state.getNotificationAppLaunchDetails();
  }

  Future<void> showFromFcmMessage({
    required FcmMessageModel message,
  }) {
    return show(
      alertId: message.id,
      title: message.title,
      body: message.body,
    );
  }

  Future<void> show({
    required String title,
    required String body,
    String? alertId,
  }) async {
    await state.show(
      id,
      title,
      body,
      notificationDetails,
      payload: alertId,
    );
    id++;
  }
}
