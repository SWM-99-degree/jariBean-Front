import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/component/custom_text_form_field.dart';
import 'package:jari_bean/common/component/oauth_login_button.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/firebase/fcm.dart';
import 'package:jari_bean/common/notification/notification.dart';
import 'package:jari_bean/common/screens/default_layout.dart';
import 'package:jari_bean/user/provider/login_provider.dart';
import 'package:jari_bean/user/provider/social_login_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '이메일',
            style: TextStyle(fontSize: 20),
          ),
          CustomTextFormField(
            hintText: '이메일을 입력해주세요',
            onChanged: (a) {
              print(a);
            },
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '비밀번호',
            style: TextStyle(fontSize: 20),
          ),
          CustomTextFormField(
            hintText: '비밀번호를 입력해주세요',
            onChanged: (a) {
              print(a);
            },
          ),
          SizedBox(
            height: 20,
          ),
          CustomButton(text: '제출', onTap: () {}),
          SizedBox(
            height: 10,
          ),
          OauthLoginButton(
              imagePath: 'assets/images/kakao_login_large_wide.png',
              onTap: () async {
                await ref
                    .read(socialLoginStateNotifierProvider.notifier)
                    .login(type: 'kakao');
                await ref.read(loginStateNotifierProvider.notifier).login();
              }),
          Text(ref.watch(fcmTokenProvider)),
          ElevatedButton(
            onPressed: () => {
              ref
                  .read(notificationStateNotifierProvider.notifier)
                  .show(title: '230723', body: 'this is a test')
            },
            child: Text('알림 보내기!'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(fcmTokenProvider.notifier).getToken();
              print(ref.read(fcmTokenProvider));
            },
            child: Text('토큰읽기!'),
          )
        ],
      ),
    );
  }
}
