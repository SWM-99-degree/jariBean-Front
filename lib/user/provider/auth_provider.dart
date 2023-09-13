import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/alert/model/alert_model.dart';
import 'package:jari_bean/alert/provider/alert_provider.dart';
import 'package:jari_bean/common/firebase/fcm.dart';
import 'package:jari_bean/common/models/fcm_message_model.dart';
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
    ref.listen(isInitProvider, (previous, next) {
      if (previous != next && next == true) {
        notifyListeners();
      }
    });
  }

  Future<void> login({required String type}) async {
    await ref.read(socialLoginProvider.notifier).login(type: type);
    await ref.read(userProvider.notifier).login(type: type);
  }

  Future<void> logout() async {
    await ref.read(userProvider.notifier).logout();
  }

  bool checkRegistered() {
    return ref.read(userProvider.notifier).checkRegistered();
  }

  FutureOr<String?> redirectAuthLogic(_, GoRouterState state) async {
    final userProviderLocal = ref.read(userProvider);

    final isLogginIn = state.location == '/login';
    final isSplashScreen = state.location == '/splash';

    if (userProviderLocal == null) {
      return isLogginIn ? null : '/login';
    }

    if (userProviderLocal is UserModel) {
      if (isSplashScreen || isLogginIn) {
        return '/register';
      }
      return null;
    }

    if (userProviderLocal is UserModelError) {
      return isLogginIn ? null : '/login';
    }

    return null;
  }

  FutureOr<String?> redirectRegisterLogic(_, GoRouterState state) async {
    if (ref.read(userProvider.notifier).checkRegistered()) {
      return '/alert';
    } else {
      return null;
    }
  }

  FutureOr<String?> redirectAlertLogic(_, GoRouterState state) async {
    final launchedWithFLNDetail = await ref.read(launchedByFLNProvider);
    final launchedWithFcmDetail = ref.read(launchedByFCMProvider);
    bool isLaunchedByFLN =
        launchedWithFLNDetail?.didNotificationLaunchApp ?? false;

    bool isLaunchedByFCM = launchedWithFcmDetail == null ? false : true;

    bool isLaunchedByAlert = isLaunchedByFLN || isLaunchedByFCM;

    bool isDisplayingAlert =
        state.location.contains('/alert') && state.pathParameters.isNotEmpty;

    if (!(isLaunchedByAlert || isDisplayingAlert)) {
      if (!isLaunchedByAlert) {
        return '/';
      }

      if (!isLaunchedByAlert) {
        return '/alert';
      }
    }

    String? alertId;
    if (isLaunchedByAlert) {
      alertId = isLaunchedByFLN
          ? launchedWithFLNDetail?.notificationResponse?.payload
          : launchedWithFcmDetail!.messageId;
      ref.read(isInitProvider.notifier).state = false;
    } else {
      alertId = state.pathParameters['id'];
    }

    if (alertId == null) {
      return '/';
    }

    final AlertModel alert =
        ref.read(alertProvider.notifier).getAlertById(alertId);
    if (alert.id == 'error') {
      return '/';
    }
    if (alert.data is MatchingSuccessModel) {
      final data = alert.data as MatchingSuccessModel;
      return '/cafe/${data.cafeId}';
    }
    if (alert.data is AnnouncementDataModel) {
      return '/alert/${alert.id}';
    }
    return null;
  }
}

final isInitProvider = StateProvider((ref) => true);
