import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';

class RootScreen extends StatelessWidget {
  static String get routerName => '/';
  final Widget child;
  const RootScreen({required this.child, super.key});

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
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/history');
              break;
            case 2:
              context.go('/alert');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
        currentIndex: () {
          switch (GoRouterState.of(context).location) {
            case '/home':
              return 0;
            case '/history':
              return 1;
            case '/alert':
              return 2;
            case '/profile':
              return 3;
            default:
              return 0;
          }
        }(),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(JariBeanIconPack.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(JariBeanIconPack.calendar),
            label: '나의 예약',
          ),
          BottomNavigationBarItem(
            icon: Icon(JariBeanIconPack.notice),
            label: '알림',
          ),
          BottomNavigationBarItem(
            icon: Icon(JariBeanIconPack.profile),
            label: '내 정보',
          ),
        ],
      ),
      child: Container(
        color: Colors.white,
        child: child,
      ),
    );
  }
}
