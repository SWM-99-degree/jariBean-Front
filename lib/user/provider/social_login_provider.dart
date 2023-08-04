import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/secure_storage/secure_storage.dart';
import 'package:jari_bean/user/models/social_login_response_model.dart';
import 'package:jari_bean/user/repository/login_repository.dart';

final socialLoginStateNotifierProvider =
    StateNotifierProvider<SocialLoginStateNotifier, SocialLoginResponseModelBase>((ref) {
  final loginRepository = ref.watch(socialLoginRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  return SocialLoginStateNotifier(loginRepository: loginRepository, storage: storage);
});

class SocialLoginStateNotifier extends StateNotifier<SocialLoginResponseModelBase> {
  final SocialLoginRepository loginRepository;
  final FlutterSecureStorage storage;
  SocialLoginStateNotifier({required this.loginRepository, required this.storage})
      : super(SocialLoginResponseModelLoading());

  Future<SocialLoginResponseModelBase> login({required String type}) async {
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
    if (state is SocialLoginResponseModelError) {
      print((state as SocialLoginResponseModelError).errorDescription);
      return state;
    }

    return state as SocialLoginResponseModel;
  }
}
