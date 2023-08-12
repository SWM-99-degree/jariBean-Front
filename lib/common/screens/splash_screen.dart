import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/dio/dio.dart';
import 'package:jari_bean/common/notification/notification.dart';
import 'package:jari_bean/common/secure_storage/secure_storage.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static String get routerName => '/splash';
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with WidgetsBindingObserver {
  AppLifecycleState? _notification;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
    print(_notification);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // checkToken();
  }

  void checkToken() async {
    final storage = ref.read(secureStorageProvider);

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final dio = ref.watch(dioProvider);

    await ref.read(notificationStateNotifierProvider.notifier).init();

    if (ref
            .read(notificationStateNotifierProvider.notifier)
            .notificationAppLaunchDetails
            ?.didNotificationLaunchApp ==
        true) {
      final String title = ref
          .read(notificationStateNotifierProvider.notifier)
          .notificationAppLaunchDetails!
          .notificationResponse!
          .payload!;
      context.go('/alert/$title');
      return;
    }

    try {
      final resp = await dio.post(
        '$ip/auth/token',
        options: Options(headers: {'authorization': 'Bearer $refreshToken'}),
      );

      await storage.write(
          key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);
      context.go('/');
    } catch (e) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.86, -0.52),
          end: Alignment(-0.86, 0.52),
          colors: [PRIMARY_YELLOW, PRIMARY_ORANGE],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '자리:Bean',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontFamily: 'Gmarket Sans TTF',
                fontWeight: FontWeight.w700,
              ),
            ),
            // Text(
            //   _notification.toString(),
            // ),
          ],
        ),
      ),
    );
  }
}
