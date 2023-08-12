import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/firebase/fcm.dart';
import 'package:jari_bean/common/notification/notification.dart';
import 'package:jari_bean/user/provider/user_provider.dart';

class TestScreen extends ConsumerWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => {
            ref
                .read(notificationStateNotifierProvider.notifier)
                .show(title: '230723', body: 'this is a test')
          },
          child: const Text('알림 보내기!'),
        ),
        ElevatedButton(
          onPressed: () => {ref.read(userProvider.notifier).logout()},
          child: const Text('로그아웃'),
        ),
        ElevatedButton(
          onPressed: () {
            context.go('/alert/123');
          },
          child: const Text('go'),
        ),
        ElevatedButton(
          onPressed: () {
            context.push('/');
          },
          child: const Text('push'),
        ),
        Text(ref.watch(fcmTokenProvider)),
      ],
    );
  }
}
