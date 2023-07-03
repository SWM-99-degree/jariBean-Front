// import 'dart:convert';
// import 'package:jari_bean/social_login.dart';
// import 'package:http/http.dart' as http;

// class KakaoOauth implements SocialLogin {
//   Future<bool> login() async {
//     try {
//       final uri = Uri.parse('https://kauth.kakao.com/oauth/authorize?client_id=1dc8739f9827f96eccc7cd66a524c434&redirect_uri=https://dev.jari-bean.com/oauth&response_type=code');
//       final response = await http.get(uri);
//       if(response.statusCode == 200){
//         this.user = User.fromJson(json.decode(response.body) as Map<String, dynamic>);
//       }else{
//         print('network error');
//         return false;
//       }
//       print('${response.body}');
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   @override
//   Future<bool> logout() async {
//     try {
//       return true;
//     } catch (error) {
//       return false;
//     }
//   }
  
//   @override
//   User? user;
// }