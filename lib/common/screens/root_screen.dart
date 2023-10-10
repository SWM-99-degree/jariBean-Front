import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/alert/screens/alert_announcement_screen.dart';
import 'package:jari_bean/alert/screens/alert_screen.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/history/screens/history_screen.dart';
import 'package:jari_bean/user/screens/profile_screen.dart';

class RootScreen extends StatelessWidget {
  static String get routerName => '/';
  final Widget child;
  const RootScreen({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    late final String appBarText;
    switch (child.runtimeType) {
      case HistoryScreen:
        appBarText = '나의 예약';
        break;
      case AlertScreen:
      case AlertAnnouncementScreen:
        appBarText = '알림';
        break;
      case ProfileScreen:
        appBarText = '내 정보';
        break;
      default:
        appBarText = '';
    }
    return DefaultLayout(
      title: appBarText,
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
              context.go(INITIAL_LOCATION);
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
          final location = GoRouterState.of(context).location;
          if (location.startsWith('/home')) return 0;
          if (location.startsWith('/history')) return 1;
          if (location.startsWith('/alert')) return 2;
          if (location.startsWith('/profile')) return 3;
          return 0;
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
