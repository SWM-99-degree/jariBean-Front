import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/alert/provider/alert_provider.dart';
import 'package:jari_bean/common/firebase/fcm.dart';
import 'package:jari_bean/common/provider/go_router_provider.dart';
import 'package:logger/logger.dart' as log;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

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

  final container = ProviderContainer();

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


  FirebaseMessaging.onMessage
      .listen((message) => fcmMessageHandler(message, container));
  FirebaseMessaging.onBackgroundMessage(
    (message) => fcmMessageHandler(message, container),
  );

  FirebaseMessaging.onMessageOpenedApp.listen(
    (message) => fcmOnOpenedAppHandler(
      message: message,
      goRouter: container.read(goRouterProvider),
      alertProvider: container.read(alertProvider.notifier),
    ),
  );

  await FirebaseMessaging.instance.getInitialMessage().then((message) {
    if (message != null) {
      fcmOnOpenedAppHandler(
        message: message,
        goRouter: container.read(goRouterProvider),
        alertProvider: container.read(alertProvider.notifier),
      );
    }
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.grey[50],
    ),
  );

  initializeDateFormatting().then(
    (_) => runApp(
      UncontrolledProviderScope(
        container: container,
        child: _App(),
      ),
    ),
  );
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
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: child!,
        ),
      ),
    );
  }
}
