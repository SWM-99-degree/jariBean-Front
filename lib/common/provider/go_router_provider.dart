import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/alert/screens/alert_screen.dart';
import 'package:jari_bean/cafe/screen/cafe_detail_screen.dart';
import 'package:jari_bean/cafe/screen/cafe_screen.dart';
import 'package:jari_bean/common/provider/home_selection_provider.dart';
import 'package:jari_bean/common/screens/home_screen.dart';
import 'package:jari_bean/history/screens/history_screen.dart';
import 'package:jari_bean/matching/screen/matching_proceeding_screen.dart';
import 'package:jari_bean/matching/screen/matching_success_screen.dart';
import 'package:jari_bean/reservation/screen/result_screen.dart';
import 'package:jari_bean/reservation/screen/search_screen.dart';
import 'package:jari_bean/user/provider/auth_provider.dart';
import 'package:jari_bean/user/screens/login_screen.dart';
import 'package:jari_bean/common/screens/root_screen.dart';
import 'package:jari_bean/common/screens/splash_screen.dart';
import 'package:jari_bean/user/screens/profile_screen.dart';
import 'package:jari_bean/user/screens/register_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    final provider = ref.read(authProvider);
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/splash',
      debugLogDiagnostics: true,
      refreshListenable: provider,
      redirect: provider.redirectAuthLogic,
      routes: [
        GoRoute(
          path: '/splash',
          name: SplashScreen.routerName,
          builder: (_, __) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routerName,
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          name: RegisterScreen.routerName,
          builder: (_, __) => const RegisterScreen(),
          redirect: provider.redirectRegisterLogic,
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            print(child);
            return RootScreen(
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: '/home',
              name: HomeScreen.routerName,
              pageBuilder: (context, state) {
                if (state.queryParameters['selection'] == 'matching') {
                  ref
                      .read(homeSelectionProvider.notifier)
                      .update(HomeSelection.matching);
                } else if (state.queryParameters['selection'] ==
                    'reservation') {
                  ref
                      .read(homeSelectionProvider.notifier)
                      .update(HomeSelection.reservation);
                }
                return NoTransitionPage(
                  child: HomeScreen(),
                );
              },
            ),
            GoRoute(
              path: '/history',
              name: HistoryScreen.routerName,
              pageBuilder: (_, __) => NoTransitionPage(
                child: HistoryScreen(),
              ),
            ),
            GoRoute(
              path: '/profile',
              name: ProfileScreen.routerName,
              pageBuilder: (_, __) => NoTransitionPage(
                child: ProfileScreen(),
              ),
            ),
            GoRoute(
              path: '/alert',
              name: AlertScreen.routerName,
              pageBuilder: (_, __) => NoTransitionPage(
                child: AlertScreen(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/cafe',
          name: CafeScreen.routerName,
          builder: (_, state) => CafeScreen(),
          routes: [
            GoRoute(
              path: ":id",
              builder: (_, state) =>
                  CafeDetailScreen(cafeId: state.pathParameters['id']!),
            ),
          ],
        ),
        GoRoute(
          path: '/search',
          name: SearchScreen.routerName,
          builder: (_, state) => SearchScreen(
            serviceAreaId: state.queryParameters['serviceAreaId'],
          ),
        ),
        GoRoute(
          path: '/result',
          name: ResultScreen.routerName,
          builder: (_, __) => const ResultScreen(
            cafeId: '1',
          ),
        ),
        GoRoute(
          path: '/matching/proceeding',
          name: '/matching/proceeding',
          builder: (_, __) => MatchingProceedingScreen(),
        ),
        GoRoute(
          path: '/matching/success',
          name: '/matching/success',
          builder: (_, __) => MatchingSuccessScreen(),
        )
      ],
    );
  },
);
