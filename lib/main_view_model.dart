import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jari_bean/social_login.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class MainViewModel{
  final SocialLogin _socialLogin;
  bool isLogined = false;
  User? user;
  AccessTokenInfo? token;

  MainViewModel(this._socialLogin);

  Future login() async{
    isLogined = await _socialLogin.login();
    if(isLogined){
      user = await UserApi.instance.me();
      token = await UserApi.instance.accessTokenInfo();
      print(user);
    }
  }
  
  Future logout() async{
    await _socialLogin.logout();
    isLogined = false;
    user = null;
  }
  //get social login user id and fcm token
  Future getFcmToken() async{
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print(fcmToken);
    if(isLogined){
      user = await UserApi.instance.me();
      print('안녕 ${UserApi.instance}');
      print(user);
    }
  }
}