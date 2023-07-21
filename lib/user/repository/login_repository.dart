import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/user/models/login_response_model.dart';

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  return LoginRepository();
});



class LoginRepository {
  LoginRepository();

  Future<LoginResponseModelBase> kakaoLogin() async {
    return await BaseWebLogin.login(
        loginUrl: kakaoLoginUrl, callbackUrlScheme: callbackUrlScheme);
  }

  Future<LoginResponseModelBase> googleLogin() async {
    return await BaseWebLogin.login(
        loginUrl: googleLoginUrl, callbackUrlScheme: callbackUrlScheme);
  }

  Future<LoginResponseModelBase> appleLogin() async {
    return await BaseWebLogin.login(
        loginUrl: appleLoginUrl, callbackUrlScheme: callbackUrlScheme);
  }
}

abstract class BaseWebLogin {

  static Future<LoginResponseModelBase> login(
      {required String loginUrl, required String callbackUrlScheme}) async {
    try {
      final response = await FlutterWebAuth.authenticate(
          url: loginUrl, callbackUrlScheme: callbackUrlScheme);
      var queryString = Uri.splitQueryString(response.split('?')[1]);
      return LoginResponseModel.fromJson(queryString);
    } catch (e) {
      return LoginResponseModelError(e, '로그인 실패!');
    }
  }
}

/*

class KakaoLogin extends BaseWebLogin{
  KakaoLogin() : super(
    loginUrl: kakaoLoginUrl,
    callbackUrlScheme: callbackUrlScheme
  );
}

class GoogleLogin extends BaseWebLogin{
  GoogleLogin() : super(
    loginUrl: googleLoginUrl,
    callbackUrlScheme: callbackUrlScheme
  );
}

class AppleLogin extends BaseWebLogin{
  AppleLogin() : super(
    loginUrl: appleLoginUrl,
    callbackUrlScheme: callbackUrlScheme
  );
}

abstract class BaseWebLogin{
  final String loginUrl;
  final String callbackUrlScheme;
  BaseWebLogin({
    required this.loginUrl,
    required this.callbackUrlScheme
  });

  Future<Map<String,String>?> login() async{
    try{
      final response = await FlutterWebAuth.authenticate(url: loginUrl, callbackUrlScheme: callbackUrlScheme);
      var queryString = Uri.splitQueryString(response);
      queryString = queryString;
      var access_token = queryString['access_token'];
      var token = response.split('token=')[1];
      return queryString;
    }
    catch(e){
      print(e);
      return null;
    }
  }
}
*/
