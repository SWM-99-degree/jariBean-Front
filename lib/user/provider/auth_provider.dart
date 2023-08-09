import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/notification/notification.dart';
import 'package:jari_bean/user/models/user_model.dart';
import 'package:jari_bean/user/provider/social_login_provider.dart';
import 'package:jari_bean/user/provider/user_provider.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(ref: ref);
});

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(
      userProvider,
      ((previous, next) {
        if (previous != next) {
          notifyListeners();
        }
      }),
    );
  }

  void login({required String type}) async {
    await ref.read(socialLoginProvider.notifier).login(type: type);
    await ref.read(userProvider.notifier).login(type: type);
  }

  void logout() {
    ref.read(userProvider.notifier).logout();
  }

  FutureOr<String?> redirectLogic(_, GoRouterState state) async {
    final openedWithNotiDetail = await ref.read(openedWithNotiProvider);
    bool isLaunchedByAlert =
        openedWithNotiDetail?.didNotificationLaunchApp ?? false;

    final userProviderLocal = ref.read(userProvider);

    final isLogginIn = state.location == '/login';
    final isSplashScreen = state.location == '/splash';
    // final isViewingAlert = state.location.contains('/alert');
    final isRegistered = ref.read(userProvider.notifier).checkRegistered;
    // final isRegistered = (ref.read(userProvider) as UserModel).isRegistered ?? false;

    if (userProviderLocal == null) {
      return isLogginIn ? null : '/login';
    }

    if (userProviderLocal is UserModel) {
      if (isLaunchedByAlert) {
        return '/alert/$openedWithNotiDetail!.notificationResponse!.payload!';
      }
      if (!isRegistered) {
        print('not registered');
        return '/register';
      }
      if (isSplashScreen || isLogginIn) {
        return '/';
      }
      return null;
    }

    if (userProviderLocal is UserModelError) {
      return isLogginIn ? null : '/login';
    }

    return null;
  }
}
