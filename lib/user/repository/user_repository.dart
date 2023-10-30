import 'package:dio/dio.dart' hide Headers;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/dio/dio.dart';
import 'package:jari_bean/user/models/login_response_model.dart';
import 'package:jari_bean/user/models/social_login_response_model.dart';
import 'package:jari_bean/user/models/user_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

part 'user_repository.g.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio, baseUrl: '$ip/api/users');
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

  @PATCH('/')
  @Headers({'accessToken': 'true', 'Content-Type': 'multipart/form-data'})
  Future updateProfile({
    @Body() required FormData body,
  });

  @DELETE('/')
  @Headers({'accessToken': 'true'})
  Future deleteAccount({
    @Body() SocialLoginResponseModel? code,
  });

  @POST('/login/{type}')
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
      loginUrl: kakaoLoginUrl,
      callbackUrlScheme: callbackUrlScheme,
    );
  }

  Future<SocialLoginResponseModelBase> googleLogin() async {
    return await SocialLogin.socialLogin(
      loginUrl: googleLoginUrl,
      callbackUrlScheme: callbackUrlScheme,
    );
  }

  Future<SocialLoginResponseModelBase> appleLogin() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      return SocialLoginResponseModel.fromJson({
        'code': credential.authorizationCode,
      });
    } catch (e) {
      return SocialLoginResponseModelError(e, '로그인 실패!');
    }
  }
}

abstract class SocialLogin {
  static Future<SocialLoginResponseModelBase> socialLogin({
    required String loginUrl,
    required String callbackUrlScheme,
  }) async {
    try {
      final response = await FlutterWebAuth.authenticate(
        url: loginUrl,
        callbackUrlScheme: callbackUrlScheme,
      );
      var queryString = Uri.splitQueryString(response.split('?')[1]);
      return SocialLoginResponseModel.fromJson(queryString);
    } catch (e) {
      return SocialLoginResponseModelError(e, '로그인 실패!');
    }
  }
}
