import 'dart:async';
import 'dart:ui';
import 'package:datadog_flutter_plugin/datadog_flutter_plugin.dart';
import 'package:datadog_tracking_http_client/datadog_tracking_http_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/exception/custom_exception_handler.dart';
import 'package:jari_bean/common/firebase/fcm.dart';
import 'package:jari_bean/common/provider/go_router_provider.dart';
import 'package:jari_bean/reservation/provider/reservation_timer_provider.dart';
import 'package:logger/logger.dart' as log;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';

var logger = log.Logger();

Future requestPermissionIOS(FirebaseMessaging fbMsg) async {
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

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (provider.runtimeType ==
        StateNotifierProvider<TimerStateNotifier, int>) {
      return;
    }
    print('''
{
  "provider": "${provider.name ?? provider.runtimeType}",
  "newValue": "$newValue"
}''');
  }
}

void main() async {
  final container = ProviderContainer(observers: [Logger()]);

  await dotenv.load(fileName: "lib/common/config/.env");
  await Firebase.initializeApp();

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
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.onTokenRefresh.listen(
    (token) => fcmTokenRefreshHandler(
      token,
      container.read(fcmTokenProvider.notifier),
    ),
  );

  FirebaseMessaging.onMessage
      .listen((message) => fcmMessageHandler(message, container));
  FirebaseMessaging.onBackgroundMessage(
    (message) => fcmMessageHandler(message, container),
  );

  FirebaseMessaging.onMessageOpenedApp.listen(
    (message) => fcmOnOpenedAppHandler(
      message: message,
      container: container,
    ),
  );

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

  final configuration = DdSdkConfiguration(
    clientToken: datadogClientToken,
    env: datadogEnv,
    site: DatadogSite.us1,
    trackingConsent: TrackingConsent.granted,
    nativeCrashReportEnabled: true,
    loggingConfiguration: LoggingConfiguration(),
    rumConfiguration: RumConfiguration(applicationId: datadogApplicationId),
    firstPartyHosts: [ip],
  )..enableHttpTracking();

  WidgetsFlutterBinding.ensureInitialized();
  final originalOnError = FlutterError.onError;
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (!kDebugMode) DatadogSdk.instance.rum?.handleFlutterError(details);
    originalOnError?.call(details);
    CustomExceptionHandler.hanldeException(details.exception);
  };
  await DatadogSdk.instance.initialize(configuration);

  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) return false;
    DatadogSdk.instance.rum?.addErrorInfo(
      error.toString(),
      RumErrorSource.source,
      stackTrace: stack,
    );
    CustomExceptionHandler.hanldeException(error);
    return true;
  };

  await initializeDateFormatting().then(
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
      designSize: MediaQuery.of(context).size.height > 700
          ? const Size(375, 812)
          : MediaQuery.of(context).size.height > 550
              ? const Size(375, 667)
              : const Size(375, 500),
      scaleByHeight: MediaQuery.of(context).size.width > 450,
      builder: (context, child) => MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
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
