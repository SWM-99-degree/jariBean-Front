import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:jari_bean/social_login.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class KakaoLogin implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          var hi = await AuthCodeClient.instance.authorizeWithTalk(
            clientId: '1dc8739f9827f96eccc7cd66a524c434',
            redirectUri: 'http://121.173.114.173:7001/oauth',
          );
          print('loginWithKakaoTalk');
          print(hi);
          return true;
        } catch (e) {
          print('loginWithKakaoTalkError');
          return false;
        }
      } else {
        try {
          // flutterwebauth login with kakaotalk
          var a = await FlutterWebAuth.authenticate(url: 'https://kauth.kakao.com/oauth/authorize?client_id=1dc8739f9827f96eccc7cd66a524c434&redirect_uri=http://121.173.114.173:7001/oauth&response_type=code', callbackUrlScheme: 'jaribean');
          print('loginWithKakaoTalkWEB');
          print(a);
          print('asdds');
          return true;
        } catch (e) {
          print(e.toString());
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