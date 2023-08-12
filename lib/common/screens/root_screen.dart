import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/common/screens/test_screen.dart';
import 'package:jari_bean/history/screens/history_screen.dart';
import 'package:jari_bean/user/screens/profile_screen.dart';

class RootScreen extends ConsumerStatefulWidget {
  static String get routerName => '/';
  const RootScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  int index = 0;

  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 4, vsync: this);

    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: PRIMARY_ORANGE,
          unselectedItemColor: TEXT_COLOR,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          // type: BottomNavigationBarType.shifting,
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            controller.animateTo(index);
          },
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(JariBeanIconPack.home), label: '홈'),
            BottomNavigationBarItem(
                icon: Icon(JariBeanIconPack.calendar), label: '나의 예약'),
            BottomNavigationBarItem(
                icon: Icon(JariBeanIconPack.notice), label: '알림'),
            BottomNavigationBarItem(
                icon: Icon(JariBeanIconPack.profile), label: '내 정보'),
          ]),
      child: TabBarView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Center(child: TestScreen()),
            Center(
              child: HistoryScreen(),
            ),
            Center(child: Container(child: Text('주문'))),
            ProfileScreen()
          ]),
    );
  }
}
