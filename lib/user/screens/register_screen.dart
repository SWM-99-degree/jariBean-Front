import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/user/provider/user_provider.dart';

class RegisterScreen extends ConsumerWidget {
  static String get routerName => '/register';
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '회원가입',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CustomButton(
              text: '회원가입',
              onPressed: () {
                ref.read(userProvider.notifier).setRegistered = true;
                context.go('/');
              },
            ),
          )
        ],
      ),
    );
  }
}
