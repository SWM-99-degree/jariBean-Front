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

Future<void> setupInteractedMessage(FirebaseMessaging fbMsg) async {
  RemoteMessage? initialMessage = await fbMsg.getInitialMessage();
  // 종료상태에서 클릭한 푸시 알림 메세지 핸들링
  if (initialMessage != null) clickMessageEvent(initialMessage);
  // 앱이 백그라운드 상태에서 푸시 알림 클릭 하여 열릴 경우 메세지 스트림을 통해 처리
  FirebaseMessaging.onMessageOpenedApp.listen(clickMessageEvent);
}

void clickMessageEvent(RemoteMessage message) {
  print('message : ${message.notification!.title}');
  Get.toNamed('/');
}

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
  print('flutter hello');
  await dotenv.load(fileName: "lib/common/config/.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging fbMsg = FirebaseMessaging.instance;

  fbMsg.onTokenRefresh.listen((event) {
    print('onTokenRefresh : $event');
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

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel? androidNotificationChannel;
  if (Platform.isIOS) {
    await requestPermissionIOS(fbMsg);
  } else if (Platform.isAndroid) {
    //Android 8 (API 26) 이상부터는 채널설정이 필수.
    androidNotificationChannel = const AndroidNotificationChannel(
      'important_channel', // id
      'Important_Notifications', // name
      description: '중요도가 높은 알림을 위한 채널.',
      // description
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }
  //Background Handling 백그라운드 메세지 핸들링
  FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
  //Foreground Handling 포어그라운드 메세지 핸들링
  FirebaseMessaging.onMessage.listen((message) {
    fcmForegroundHandler(
        message, flutterLocalNotificationsPlugin, androidNotificationChannel);
  });

  await setupInteractedMessage(fbMsg);
}