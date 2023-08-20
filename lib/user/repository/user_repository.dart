import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/dio/dio.dart';
import 'package:jari_bean/user/models/login_response_model.dart';
import 'package:jari_bean/user/models/social_login_response_model.dart';
import 'package:jari_bean/user/models/user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(dio, baseUrl: '$ip/user');
  final dio = ref.watch(dioProvider);
});

@RestApi()
abstract class UserRepository {
  factory UserRepository(Dio dio, {String baseUrl}) = _UserRepository;

  @GET('/me')
  @Headers({'accessToken': 'true'})
  Future<UserModel> getMe();

  @PUT('/register')
  @Headers({'accessToken': 'true'})
  Future<UserModel> register();
}

final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return LoginRepository(
    dio,
    baseUrl: '$ip/login',
  );
});

@RestApi()
abstract class LoginRepository {
  factory LoginRepository(Dio dio, {String baseUrl}) = _LoginRepository;

  @POST('/{type}')
  Future<LoginResponseModel> login({
    @Path('type') required String type,
    @Body() required SocialLoginResponseModel body,
  });
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
