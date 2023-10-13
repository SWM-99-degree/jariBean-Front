import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/alert/screens/alert_announcement_screen.dart';
import 'package:jari_bean/alert/screens/alert_screen.dart';
import 'package:jari_bean/cafe/screen/cafe_detail_screen.dart';
import 'package:jari_bean/cafe/screen/cafe_screen.dart';
import 'package:jari_bean/common/provider/home_selection_provider.dart';
import 'package:jari_bean/common/screens/home_screen.dart';
import 'package:jari_bean/history/provider/hisotry_selection_provider.dart';
import 'package:jari_bean/history/screens/history_screen.dart';
import 'package:jari_bean/matching/screen/matching_proceeding_screen.dart';
import 'package:jari_bean/matching/screen/matching_success_screen.dart';
import 'package:jari_bean/reservation/screen/result_screen.dart';
import 'package:jari_bean/reservation/screen/search_screen.dart';
import 'package:jari_bean/user/provider/auth_provider.dart';
import 'package:jari_bean/user/screens/login_screen.dart';
import 'package:jari_bean/common/screens/root_screen.dart';
import 'package:jari_bean/common/screens/splash_screen.dart';
import 'package:jari_bean/user/screens/profile_edit_screen.dart';
import 'package:jari_bean/user/screens/profile_screen.dart';
import 'package:jari_bean/user/screens/register_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

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
          path: '/',
          name: RootScreen.routerName,
          builder: (_, __) => const RootScreen(
            child: HomeScreen(),
          ),
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
              path: 'home',
              name: HomeScreen.routerName,
              pageBuilder: (context, state) {
                Future(() {
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
                });
                return NoTransitionPage(
                  child: RootScreen(
                    child: HomeScreen(),
                  ),
                );
              },
            ),
            GoRoute(
              path: 'history',
              name: HistoryScreen.routerName,
              pageBuilder: (context, state) {
                Future(() {
                  if (state.queryParameters['selection'] == 'matching') {
                    ref
                        .read(historySelectionProvider.notifier)
                        .update(HistorySelection.matching);
                  } else if (state.queryParameters['selection'] ==
                      'reservation') {
                    ref
                        .read(historySelectionProvider.notifier)
                        .update(HistorySelection.reservation);
                  }
                });
                return NoTransitionPage(
                  child: RootScreen(
                    child: HistoryScreen(),
                  ),
                );
              },
            ),
            GoRoute(
              path: 'alert',
              name: AlertScreen.routerName,
              pageBuilder: (_, __) => NoTransitionPage(
                child: RootScreen(
                  child: AlertScreen(),
                ),
              ),
              routes: [
                GoRoute(
                  path: 'announcement',
                  name: AlertAnnouncementScreen.routerName,
                  pageBuilder: (_, __) => NoTransitionPage(
                    child: RootScreen(
                      child: AlertAnnouncementScreen(),
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'profile',
              name: ProfileScreen.routerName,
              pageBuilder: (_, __) => NoTransitionPage(
                child: RootScreen(
                  child: ProfileScreen(),
                ),
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  name: ProfileEditScreen.routerName,
                  pageBuilder: (_, __) => NoTransitionPage(
                    child: ProfileEditScreen(),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'cafe',
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
              path: 'search',
              name: SearchScreen.routerName,
              builder: (_, state) => SearchScreen(
                serviceAreaId: state.queryParameters['serviceAreaId'],
              ),
            ),
            GoRoute(
              path: 'result',
              name: ResultScreen.routerName,
              builder: (_, __) => const ResultScreen(
                cafeId: '1',
              ),
            ),
            GoRoute(
              path: 'matching/proceeding',
              name: 'matching/proceeding',
              builder: (_, __) => MatchingProceedingScreen(),
            ),
            GoRoute(
              path: 'matching/success',
              name: 'matching/success',
              builder: (_, __) => MatchingSuccessScreen(),
            ),
          ],
        ),
      ],
    );
  },
);
