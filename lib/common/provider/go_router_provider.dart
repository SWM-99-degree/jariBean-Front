import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/alert/screens/alert_screen.dart';
import 'package:jari_bean/user/provider/auth_provider.dart';
import 'package:jari_bean/user/screens/login_screen.dart';
import 'package:jari_bean/common/screens/root_screen.dart';
import 'package:jari_bean/common/screens/splash_screen.dart';
import 'package:jari_bean/user/screens/register_screen.dart';

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    final provider = ref.read(authProvider);
    return GoRouter(
      initialLocation: '/splash',
      debugLogDiagnostics: true,
      refreshListenable: provider,
      routes: [
        GoRoute(
          path: '/',
          name: RootScreen.routerName,
          builder: (_, __) => const RootScreen(),
          redirect: provider.redirectLogic,
          routes: [
            GoRoute(
              path: 'splash',
              name: SplashScreen.routerName,
              builder: (_, __) => const SplashScreen(),
            ),
            GoRoute(
              path: 'login',
              name: LoginScreen.routerName,
              builder: (_, __) => const LoginScreen(),
            ),
            GoRoute(
              path: 'register',
              name: RegisterScreen.routerName,
              builder: (_, __) => const RegisterScreen(),
            ),
            GoRoute(
              path: 'alert/:title',
              name: AlertScreen.routerName,
              builder: (_, state) =>
                  AlertScreen(title: state.pathParameters['title']!),
            )
          ],
        )
      ],
    );
  },
);