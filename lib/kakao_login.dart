import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:jari_bean/social_login.dart';
class KakaoLogin implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          await UserApi.instance.loginWithKakaoTalk();
          print('loginWithKakaoTalk');
          return true;
        } catch (e) {
          print('loginWithKakaoTalkError');
          return false;
        }
      } else {
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('loginWithKakaoTalkWEB');
          return true;
        } catch (e) {
          print('loginWithKakaoTalkWEBFalse');
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      return false;
    }
  }

}