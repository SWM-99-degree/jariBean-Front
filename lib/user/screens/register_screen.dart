import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:jari_bean/common/screens/default_layout.dart';

class RegisterScreen extends StatelessWidget {
  static String get routerName => '/register';
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: Text('RegisterScreen'));
  }
}