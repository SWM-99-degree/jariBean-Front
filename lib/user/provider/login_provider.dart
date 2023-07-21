import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/secure_storage/secure_storage.dart';
import 'package:jari_bean/user/models/login_response_model.dart';
import 'package:jari_bean/user/repository/login_repository.dart';

final loginStateNotifierProvider =
    StateNotifierProvider<LoginStateNotifier, LoginResponseModelBase>((ref) {
  final loginRepository = ref.watch(loginRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  return LoginStateNotifier(loginRepository: loginRepository, storage: storage);
});

class LoginStateNotifier extends StateNotifier<LoginResponseModelBase> {
  final LoginRepository loginRepository;
  final FlutterSecureStorage storage;
  LoginStateNotifier({required this.loginRepository, required this.storage})
      : super(LoginResponseModelLoading());

  Future<LoginResponseModelBase> login({required String type}) async {
    switch (type) {
      case 'kakao':
        state = await loginRepository.kakaoLogin();
        break;
      case 'google':
        state = await loginRepository.googleLogin();
        break;
      case 'apple':
        state = await loginRepository.appleLogin();
        break;
    }
    if (state is LoginResponseModelError) {
      print((state as LoginResponseModelError).errorDescription);
      return state;
    }

    final pState = state as LoginResponseModel;

    final accessToken = pState.accessToken;
    final refreshToken = pState.refreshToken;

    await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);
    await storage.write(key: REFRESH_TOKEN_KEY, value: refreshToken);

    return state;
  }
}
