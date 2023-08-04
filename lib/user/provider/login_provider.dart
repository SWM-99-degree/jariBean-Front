import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/secure_storage/secure_storage.dart';
import 'package:jari_bean/user/models/login_response_model.dart';
import 'package:jari_bean/user/models/social_login_response_model.dart';
import 'package:jari_bean/user/provider/social_login_provider.dart';
import 'package:jari_bean/user/repository/login_repository.dart';

final loginStateNotifierProvider =
    StateNotifierProvider<LoginStateNotifier, LoginResponseModelBase>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final socialLoginResponse = ref.watch(socialLoginStateNotifierProvider);
  final storage = ref.watch(secureStorageProvider);
  return LoginStateNotifier(
      userRepository: userRepository,
      storage: storage,
      socialLoginResponse: socialLoginResponse);
});

class LoginStateNotifier extends StateNotifier<LoginResponseModelBase> {
  final UserRepository userRepository;
  final FlutterSecureStorage storage;
  final SocialLoginResponseModelBase socialLoginResponse;
  LoginStateNotifier(
      {required this.userRepository,
      required this.storage,
      required this.socialLoginResponse})
      : super(LoginResponseModelLoading());

  login() async {
    try {
      state = await userRepository.login(
        type: (socialLoginResponse as SocialLoginResponseModel).type,
          body: socialLoginResponse as SocialLoginResponseModel);
      // fetch token with user info of social login from SocialLoginResponse
      final pState = state as LoginResponseModel;
      await storage.write(key: REFRESH_TOKEN_KEY, value: pState.refreshToken);
      await storage.write(key: ACCESS_TOKEN_KEY, value: pState.accessToken);
    } catch (e) {
      print(e);
      state = LoginResponseModelError(e, '로그인 중 오류가 발생했습니다.');
    }
  }
}
