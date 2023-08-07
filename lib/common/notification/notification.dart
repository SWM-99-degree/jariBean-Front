import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/provider/go_router_provider.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'jari_bean_alert', // id
  '자리:빈 알림', // title
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
  // notificationCategories: [
  //   DarwinNotificationCategory(
  //     'jariBean Alert',
  //     actions: <DarwinNotificationAction>[
  //       DarwinNotificationAction.text(
  //         'text_1',
  //         'Action 1',
  //         buttonTitle: 'Send',
  //         placeholder: 'Placeholder',
  //       ),
  //     ],
  //   )
  // ],
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
  iOS: const DarwinNotificationDetails(
    badgeNumber: 1,
    subtitle: '자리:빈',
    sound: 'slow_spring_board.aiff',
  ),
);

final notificationStateNotifierProvider = StateNotifierProvider<
    NotificationStateNotifier, FlutterLocalNotificationsPlugin>((ref) {
  return NotificationStateNotifier();
});

class NotificationStateNotifier
    extends StateNotifier<FlutterLocalNotificationsPlugin> {
  int id = 0;
  NotificationAppLaunchDetails? notificationAppLaunchDetails;
  NotificationStateNotifier()
      : super(FlutterLocalNotificationsPlugin()) {
    init();
  }

  Future<void> init() async {
    await state
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    notificationAppLaunchDetails =
        await state.getNotificationAppLaunchDetails();

    await state.initialize(initSettings,
        onDidReceiveBackgroundNotificationResponse: 
            onDidReceiveBackgroundNotification,
        onDidReceiveNotificationResponse: (details) {
          if (details.payload == 'test') {
            print('test success');
            // router.go('/');
          }
        });
  }

  Future<void> show({
    required String title,
    required String body,
  }) async {
    await state.show(id, title, body, notificationDetails, payload: 'test');
    id++;
  }
}

@pragma('vm:entry-point')
onDidReceiveBackgroundNotification(NotificationResponse resp) {
  print('background : ${resp.payload}');
  // router.go('/');
}
