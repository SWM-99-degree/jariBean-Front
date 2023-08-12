import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/user/models/login_response_model.dart';
import 'package:jari_bean/user/models/social_login_response_model.dart';
import 'package:jari_bean/user/models/user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = Dio(); // 딱 한번만 Singleton으로 사용하지 않음
  return UserRepository(dio, baseUrl: '$ip/user');
});

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @POST('/login/{type}')
  Future<LoginResponseModel> login({
    @Path('type') required String type,
    @Body() required SocialLoginResponseModel body,
  });

  @GET('/me')
  @Headers({'accessToken': 'true'})
  Future<UserModel> getMe();

  @POST('/register')
  @Headers({'accessToken': 'true'})
  Future<UserModel> register();
}

final socialLoginRepositoryProvider = Provider<SocialLoginRepository>((ref) {
  return SocialLoginRepository();
});

class SocialLoginRepository {
  SocialLoginRepository();

  Future<SocialLoginResponseModelBase> kakaoLogin() async {
    return await SocialLogin.socialLogin(
        loginUrl: kakaoLoginUrl, callbackUrlScheme: callbackUrlScheme);
  }

  Future<SocialLoginResponseModelBase> googleLogin() async {
    return await SocialLogin.socialLogin(
        loginUrl: googleLoginUrl, callbackUrlScheme: callbackUrlScheme);
  }

  Future<SocialLoginResponseModelBase> appleLogin() async {
    return await SocialLogin.socialLogin(
        loginUrl: appleLoginUrl, callbackUrlScheme: callbackUrlScheme);
  }
}

abstract class SocialLogin {
  static Future<SocialLoginResponseModelBase> socialLogin(
      {required String loginUrl, required String callbackUrlScheme}) async {
    try {
      final response = await FlutterWebAuth.authenticate(
          url: loginUrl, callbackUrlScheme: callbackUrlScheme);
      var queryString = Uri.splitQueryString(response.split('?')[1]);
      return SocialLoginResponseModel.fromJson(queryString);
    } catch (e) {
      return SocialLoginResponseModelError(e, '로그인 실패!');
    }
  }
}
