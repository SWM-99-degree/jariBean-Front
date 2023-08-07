import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:jari_bean/common/screens/default_layout.dart';

class AlertScreen extends StatelessWidget {
  static String get routerName => '/alert';
  final String title;
  const AlertScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Center(
        child: Text(title+'12312323'),
      ),
    );
  }
}
