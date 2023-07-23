import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/firebase/fcm.dart';
import 'package:jari_bean/common/screens/splash_screen.dart';
import 'package:logger/logger.dart' as log;
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var logger = log.Logger();

// Future<void> setupInteractedMessage(FirebaseMessaging fbMsg) async {
//   RemoteMessage? initialMessage = await fbMsg.getInitialMessage();
//   // 종료상태에서 클릭한 푸시 알림 메세지 핸들링
//   if (initialMessage != null) clickMessageEvent(initialMessage);
//   // 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메세지 스트림을 통해 처리
//   FirebaseMessaging.onMessageOpenedApp.listen(clickMessageEvent);
// }

// void clickMessageEvent(RemoteMessage message) {
//   print('message : ${message.notification!.title}');
//   Get.toNamed('/');
// }

Future requestPermissionIOS(FirebaseMessaging fbMsg) async {
  NotificationSettings settings = await fbMsg.requestPermission(
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

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  FirebaseMessaging.instance.onTokenRefresh.listen((event) {
    print('onTokenRefresh : $event');
  });

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importansssce_channel', // id
    'High Importansssce Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

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
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
  );

  Timer(const Duration(seconds: 10), () {
    flutterLocalNotificationsPlugin.show(
      0,
      '자리빈 Test',
      '230723',
      NotificationDetails(
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
      ),
    );
   });

  runApp(
    const ProviderScope(
      child: MaterialApp(
        home: Scaffold(
          body: SplashScreen(),
        ),
      ),
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
