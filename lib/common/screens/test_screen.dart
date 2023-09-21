import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/model/alert_model.dart';
import 'package:jari_bean/alert/provider/alert_provider.dart';
import 'package:jari_bean/common/firebase/fcm.dart';
import 'package:jari_bean/common/models/fcm_message_model.dart';
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
                .read(notificationProvider.notifier)
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
            Clipboard.setData(ClipboardData(text: ref.read(fcmTokenProvider)));
          },
          child: const Text('push'),
        ),
        ElevatedButton(
          onPressed: () async {
            final provider = ref.read(alertProvider.notifier);
            final alert = AlertModel(
              id: 'test-id${DateTime.now()}',
              title: '자리빈에 오신것을 환영합니다',
              isRead: false,
              body: '메뚜기 월드에 오신걸 환영합니다~',
              type: PushMessageType.announcement,
              receivedAt: DateTime.now(),
              data: FcmDataModelBase(),
            );
            await provider.insert(alert);
          },
          child: const Text(''),
        ),
        Text(ref.watch(fcmTokenProvider)),
      ],
    );
  }
}
