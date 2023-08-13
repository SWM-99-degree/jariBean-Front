import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final String? title;
  final Widget? bottomNavigationBar;

  const DefaultLayout(
      {required this.child,
      this.backgroundColor,
      this.title,
      this.bottomNavigationBar,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) return null;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        title!,
        style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pretendard'),
      ),
      foregroundColor: Colors.black,
    );
  }
}
