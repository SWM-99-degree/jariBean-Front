import 'package:flutter/widgets.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';

class AlertScreen extends StatelessWidget {
  static String get routerName => '/alert';
  const AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '알림',
      child: Center(
        child: Text('Test'),
      ),
    );
  }
}
