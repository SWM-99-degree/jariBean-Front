import 'package:flutter/material.dart';
import 'package:jari_bean/common/screens/default_layout.dart';

class RootScreen extends StatefulWidget {
  static String get routerName => '/';
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
          ),
        ],
      ),
    );
  }
}
