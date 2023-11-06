import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/exception/custom_exception.dart';
import 'package:jari_bean/user/models/social_login_response_model.dart';
import 'package:jari_bean/user/models/user_model.dart';
import 'package:jari_bean/user/provider/social_login_provider.dart';
import 'package:jari_bean/user/provider/user_provider.dart';
import 'package:jari_bean/user/repository/user_repository.dart';

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

  Future<bool> deleteAccount({required String type}) async {
    late final SocialLoginResponseModel? pCode;
    if (type == 'apple') {
      final code = await ref.read(socialLoginRepositoryProvider).appleLogin();
      if (code is SocialLoginResponseModelError) {
        throw AppleSocialLoginException();
      }
      pCode = code as SocialLoginResponseModel;
    } else {
      pCode = null;
    }
    if (!await ref.read(userProvider.notifier).deleteAccount(code: pCode)) {
      throw AccountDeleteException();
    }
    logout();
    return true;
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
      return '/register';
    }
    return INITIAL_LOCATION;
  }
}

final isInitProvider = StateProvider((ref) => true);
