import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/firebase/fcm.dart';
import 'package:jari_bean/common/notification/notification.dart';
import 'package:jari_bean/common/provider/go_router_provider.dart';
import 'package:logger/logger.dart' as log;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var logger = log.Logger();

Future requestPermissionIOS(FirebaseMessaging fbMsg) async {
  // NotificationSettings settings =
  await fbMsg.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "lib/common/config/.env");
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen(fcmMessageHandler);
  FirebaseMessaging.onBackgroundMessage(fcmMessageHandler);

  FirebaseMessaging.instance.onTokenRefresh.listen(fcmTokenRefreshHandler);

  await ProviderContainer().read(openedWithNotiProvider);

  runApp(
    const ProviderScope(
      child: _App(),
    ),
  );

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // AndroidNotificationChannel? androidNotificationChannel;
  // if (Platform.isIOS) {
  //   await requestPermissionIOS(fbMsg);
  // } else if (Platform.isAndroid) {
  //   //Android 8 (API 26) 이상부터는 채널설정이 필수.
  //   androidNotificationChannel = const AndroidNotificationChannel(
  //     'important_channel', // id
  //     'Important_Notifications', // name
  //     description: '중요도가 높은 알림을 위한 채널.',
  //     // description
  //     importance: Importance.high,
  //   );

  //   await flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()
  //       ?.createNotificationChannel(androidNotificationChannel);
  // }
  //Background Handling 백그라운드 메세지 핸들링
  // FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
  // //Foreground Handling 포어그라운드 메세지 핸들링
  // FirebaseMessaging.onMessage.listen((message) {
  //   fcmForegroundHandler(
  //       message, flutterLocalNotificationsPlugin, androidNotificationChannel);
  // });

  // await setupInteractedMessage(fbMsg);
}

class _App extends ConsumerWidget {
  const _App();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}
