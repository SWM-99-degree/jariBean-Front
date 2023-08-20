import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/secure_storage/secure_storage.dart';
import 'package:jari_bean/user/models/social_login_response_model.dart';
import 'package:jari_bean/user/models/user_model.dart';
import 'package:jari_bean/user/provider/social_login_provider.dart';
import 'package:jari_bean/user/repository/user_repository.dart';

final userProvider =
    StateNotifierProvider<UserStateNotifier, UserModelBase?>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final loginRepository = ref.watch(loginRepositoryProvider);
  final socialLoginResponse = ref.watch(socialLoginProvider);
  final storage = ref.watch(secureStorageProvider);
  return UserStateNotifier(
      loginRepository: loginRepository,
      userRepository: userRepository,
      storage: storage,
      socialLoginResponse: socialLoginResponse);
});

class UserStateNotifier extends StateNotifier<UserModelBase?> {
  final LoginRepository loginRepository;
  final UserRepository userRepository;
  final FlutterSecureStorage storage;
  final SocialLoginResponseModelBase socialLoginResponse;
  UserStateNotifier({
    required this.loginRepository,
    required this.userRepository,
    required this.storage,
    required this.socialLoginResponse,
  }) : super(UserModelLoading()) {
    getMe();
  }

  getMe() async {
    try {
      final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
      final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

      if (accessToken == null || refreshToken == null) {
        state = null;
        return;
      }

      final resp = await userRepository.getMe();
      state = resp;
    } catch (e) {
      print(e);
      state = UserModelError(e, '프로필을 가져오던 중 오류가 발생했습니다.');
    }
  }

  login({required String type}) async {
    try {
      state = UserModelLoading();

      final socialLoginResp = socialLoginResponse as SocialLoginResponseModel;

      final resp =
          await loginRepository.login(type: type, body: socialLoginResp);

      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);

      state = await userRepository.getMe();
    } catch (e) {
      print(e);
      state = UserModelError(e, '로그인 중 오류가 발생했습니다.');
    }
  }

  logout() async {
    state = null;

    await Future.wait(
      [
        storage.delete(key: ACCESS_TOKEN_KEY),
        storage.delete(key: REFRESH_TOKEN_KEY),
      ],
    );
  }

  register() async {
    try {
      state = UserModelLoading();

      final resp = await userRepository.register();

      state = resp;
    } catch (e) {
      print(e);
      state = UserModelError(e, '회원가입 중 오류가 발생했습니다.');
    }
  }

  bool checkRegistered() {
    if (state == null || state is UserModelLoading) {
      return false;
    }
    /* ISSUE 64 */
    return true;
    
    // final pState = state as UserModel;
    // return pState.role != Role.UNREGISTERED;
  }
}
