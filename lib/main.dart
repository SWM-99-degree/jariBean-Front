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

class dialogString {
  String? title;
  String? content;
  dialogString(this.title, this.content);
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
  print(
      'And the MESSAGE was : ${message.notification!.title} + ${message.notification!.body}');
}

Future fbMsgForegroundHandler(
    RemoteMessage message,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    AndroidNotificationChannel? channel) async {
  print('[FCM - Foreground] MESSAGE : ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
    flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification?.title,
        message.notification?.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
              channel!.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: const DarwinNotificationDetails(
              badgeNumber: 1,
              subtitle: 'the subtitle',
              sound: 'slow_spring_board.aiff',
            )));
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
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']);
  FirebaseMessaging fbMsg = FirebaseMessaging.instance;

  var fcmToken = await FirebaseMessaging.instance.getToken();
  fbMsg.onTokenRefresh.listen((event) {
    print('onTokenRefresh : $event');
  });

//  runApp(MaterialApp(home: Scaffold(body: Screen())));
  runApp(
    ProviderScope(
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
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //Foreground Handling 포어그라운드 메세지 핸들링
  FirebaseMessaging.onMessage.listen((message) {
    fbMsgForegroundHandler(
        message, flutterLocalNotificationsPlugin, androidNotificationChannel);
  });

  await setupInteractedMessage(fbMsg);
}
/*
class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}
class _ScreenState extends State<Screen> {
  final myControllerEmail = TextEditingController();
  final myControllerPW = TextEditingController();
  final viewModel = MainViewModel(KakaoLogin());
  late Future<dialogString> resultString;
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessageOpenedApp.listen(clickMessageEvent);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Email'),
              controller: myControllerEmail,
            )),
        Container(
            margin: const EdgeInsets.all(8),
            child: TextField(
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Password'),
              controller: myControllerPW,
            )),
        FloatingActionButton(
            child: Icon(Icons.app_registration_rounded),
            onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  resultString = AuthManage()
                      .createUser(myControllerEmail.text, myControllerPW.text);
                  return FutureBuilder(
                      future: resultString,
                      builder: (BuildContext context,
                          AsyncSnapshot<dialogString> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: Colors.red,
                          ));
                        }
                        return AlertDialog(
                            title: DefaultTextStyle(
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.black),
                              child: Text(snapshot.data?.title ?? 'null'),
                            ),
                            content: DefaultTextStyle(
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: Colors.black),
                              child: Text(snapshot.data?.content ?? 'null'),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ]);
                      });
                })),
        Text('${viewModel.isLogined}',
            style: Theme.of(context).textTheme.headline4),
        Text(
            '현재 로그인한 유저 : ${viewModel.user == null ? '없음' : viewModel.user!.id}',
            style: Theme.of(context).textTheme.headline4),
        Text(
            '현재 로그인한 유저 : ${viewModel.token == null ? '없음' : viewModel.token!}',
            style: Theme.of(context).textTheme.headline4),
        FloatingActionButton(
          child: Icon(Icons.login_rounded),
          onPressed: () async {
            await viewModel.login();
            setState(() {});
          },
        ),
        FloatingActionButton(
          child: Icon(Icons.logout_rounded),
          onPressed: () async {
            await viewModel.logout();
            setState(() {});
          },
        ),
        FloatingActionButton(
          child: Text('FCM토큰'),
          onPressed: () async {
            await viewModel.getFcmToken();
            setState(() {});
          },
        ),
      ],
    );
  }
}*/