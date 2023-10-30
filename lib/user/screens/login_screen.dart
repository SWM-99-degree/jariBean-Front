import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/component/oauth_login_button.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/user/models/user_model.dart';
import 'package:jari_bean/user/provider/auth_provider.dart';
import 'package:jari_bean/user/provider/user_provider.dart';

class LoginScreen extends ConsumerWidget {
  static String get routerName => '/login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async => false,
      child: DefaultLayout(
        child: Stack(
          children: [
            if (ref.watch(userProvider) is UserModelLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    '자리:Bean',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: PRIMARY_YELLOW,
                      fontSize: 40,
                      fontFamily: 'Gmarket Sans TTF',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OauthLoginButton(
                      imagePath: 'assets/images/kakao_login_large_wide.png',
                      onPressed: () async {
                        await ref.read(authProvider).login(type: 'kakao');
                      },
                    ),
                    const SizedBox(height: 12),
                    if (Platform.isIOS)
                      OauthLoginButton(
                        imagePath: 'assets/images/apple_login_large_wide.png',
                        onPressed: () async {
                          await ref.read(authProvider).login(type: 'apple');
                        },
                      ),
                    const SizedBox(height: 12),
                    OauthLoginButton(
                      imagePath: 'assets/images/google_login_large_wide.png',
                      onPressed: () async {
                        await ref.read(authProvider).login(type: 'google');
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
