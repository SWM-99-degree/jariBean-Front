import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/alert/screens/alert_details_screen.dart';
import 'package:jari_bean/alert/screens/alert_screen.dart';
import 'package:jari_bean/reservation/screen/search_screen.dart';
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
      redirect: provider.redirectAuthLogic,
      routes: [
        GoRoute(
          path: '/',
          name: RootScreen.routerName,
          builder: (_, __) => const RootScreen(),
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
              redirect: provider.redirectRegisterLogic,
            ),
            GoRoute(
              path: 'alert',
              name: AlertScreen.routerName,
              builder: (_, state) => const AlertScreen(),
              routes: [
                GoRoute(
                  path: ":id",
                  name: AlertDetailsScreen.routerName,
                  builder: (_, state) =>
                      AlertDetailsScreen(alertId: state.pathParameters['id']!),
                ),
              ],
              redirect: provider.redirectAlertLogic,
            ),
            GoRoute(
              path: 'search',
              name: SearchScreen.routerName,
              builder: (_, state) => SearchScreen(
                serviceAreaId: state.queryParameters['serviceAreaId'],
              ),
            ),
          ],
        )
      ],
    );
  },
);
