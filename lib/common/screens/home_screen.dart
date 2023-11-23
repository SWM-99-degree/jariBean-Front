import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/alert/model/alert_model.dart';
import 'package:jari_bean/alert/repository/alert_repository.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/firebase/fcm.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/models/fcm_message_model.dart';
import 'package:jari_bean/common/notification/notification.dart';
import 'package:jari_bean/common/provider/home_selection_provider.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/matching/model/matching_status_model.dart';
import 'package:jari_bean/matching/provider/matching_info_provider.dart';
import 'package:jari_bean/matching/repository/matching_repository.dart';
import 'package:jari_bean/matching/screen/matching_home_screen.dart';
import 'package:jari_bean/matching/screen/matching_success_screen.dart';
import 'package:jari_bean/reservation/screen/reservation_home_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static String get routerName => '/home';
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: ref.read(homeSelectionProvider).index,
  );
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.h);
  bool matchingFlag = false;

  final List<String> _tabs = ['자리 예약하기', '실시간 매칭하기'];
  @override
  void initState() {
    super.initState();
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _scrollController.animateTo(
          ((matchingFlag && _tabController.index == 0) ? 176.h : 0) + 50.h,
          duration: Duration(milliseconds: matchingFlag ? 250 : 150),
          curve: Curves.easeInOut,
        );
        if (_tabController.index == 1) {
          ref.read(homeSelectionProvider.notifier).update(
                HomeSelection.matching,
              );
        } else {
          ref.read(homeSelectionProvider.notifier).update(
                HomeSelection.reservation,
              );
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          fcmOnOpenedAppHandler(
            message: message,
            container: ProviderScope.containerOf(context),
          );
        }
      });

      final matchingStatus =
          await ref.read(matchingRepositoryProvider).getMatchingStatus();
      switch (matchingStatus.status) {
        case MatchingStatus.NORMAL:
          break;
        case MatchingStatus.ENQUEUED:
          ref
              .read(notificationProvider.notifier)
              .show(title: '매칭 안내', body: '현재 매칭이 진행중이에요');
          break;
        case MatchingStatus.PROCESSING:
          ref.read(matchingInfoProvider.notifier).applyMatchingInfo(
                matchingId: matchingStatus.matchingId!,
                cafeId: matchingStatus.cafeId!,
                startTime: matchingStatus.startTime!,
              );
          ref.read(matchingTimerProvider.notifier).initTimer(
                initTimeLeft: 600 -
                    (DateTime.now().difference(matchingStatus.startTime!))
                        .inSeconds,
              );
          ref.read(homeSelectionProvider.notifier).update(
                HomeSelection.matching,
              );
          break;
      }

      if (kDebugMode) {
        final alert = await ref.read(alertRepositoryProvider);
        for (int i = 0; i < 300; i++) {
          if (i % 3 == 0) {
            AlertModel alertModel = AlertModel(
              id: i.toString(),
              title: '[Matching Success] 자리빈에 오신것을 환영합니다]',
              isRead: false,
              body: '메뚜기 월드에 오신걸 환영합니다~',
              type: PushMessageType.matchingSuccess,
              receivedAt: DateTime.now().subtract(Duration(days: 1)),
              data: MatchingSuccessModel(
                cafeId: '123',
                matchingId: '123',
              ),
            );
            await alert.insertAlert(alertModel);
          } else if (i % 3 == 1) {
            AlertModel alertModel = AlertModel(
              id: i.toString(),
              title: '[Matching Fail] 자리빈에 오신것을 환영합니다]',
              isRead: false,
              body: '메뚜기 월드에 오신걸 환영합니다~',
              type: PushMessageType.matchingFail,
              receivedAt: DateTime.now().subtract(Duration(days: 1)),
              data: MatchingFailModel(),
            );
            await alert.insertAlert(alertModel);
          } else {
            AlertModel alertModel = AlertModel(
              id: i.toString(),
              title: '[Reservation Complete] 자리빈에 오신것을 환영합니다]',
              isRead: false,
              body: '메뚜기 월드에 오신걸 환영합니다~',
              type: PushMessageType.reservationComplete,
              receivedAt: DateTime.now().subtract(Duration(days: 1)),
              data: ReservationDataModel(
                reservationId: '123',
              ),
            );
            await alert.insertAlert(alertModel);
          }
        }

        // get alert with data test
        print('get alert with data test');
        final alert199 = await alert.getAlert('199');
        print('alert 199 : ${alert199.toJson()}');
        final alertData = await alert.getAlertWithData(alert199);
        print('alert 199 with data : ${alertData.toJson()}');

        // marking alert as read
        print('marking alert as read');

        print('before : ${(await alert.getAlert('299')).toJson()}');
        await alert.markAsRead('299');
        final alert299 = await alert.getAlert('299');

        print('after : ${alert299.toJson()}');

        final alertData1 = await alert.getAlertWithData(alert299);
        print(alertData1);

        // delete test
        print('delete test');

        print('delete alert 299');
        await alert.deleteAlert('299');
        try {
          print('try to get alert 299');
          print(await alert.getAlert('299'));
        } catch (e) {
          print(e);
        }

        try {
          print('try to get alert 299 with data : foreign key constraint');
          print('${(await alert.getAlertWithData(alert299)).toJson()}');
        } catch (e) {
          print(e);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matchingInfo = ref.watch(matchingInfoProvider);
    matchingFlag = matchingInfo != null;
    final index = ref.watch(homeSelectionProvider);
    _tabController.index = index.index;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: const [PRIMARY_YELLOW, PRIMARY_ORANGE],
        ),
      ),
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, _) => [
              SliverAppBar(
                toolbarHeight: (matchingFlag) ? 176.h : 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: const [PRIMARY_YELLOW, PRIMARY_ORANGE],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Icon(
                          JariBeanIconPack.ok_sign,
                          size: 52.w,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          '매칭 성공',
                          textAlign: TextAlign.center,
                          style: defaultFontStyleWhite.copyWith(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                backgroundColor: Colors.transparent,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    tabs: _tabs
                        .asMap()
                        .entries
                        .map(
                          (e) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Tab(
                                  child: Text(
                                    e.value,
                                    style: defaultFontStyleWhite.copyWith(
                                      color: Colors.white.withOpacity(
                                        (index.index == e.key) ? 1 : 0.5,
                                      ),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12.h + 20,
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
            body: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 30.h),
                child: index == HomeSelection.reservation
                    ? ReservationHomeScreen()
                    : matchingFlag
                        ? MatchingSuccessScreen()
                        : MatchingHomeScreen(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => 55.h + 20;

  @override
  double get maxExtent => 55.h + 20;

  double scrollAnimationValue(double shrinkOffset) {
    double value = (shrinkOffset) / (maxExtent - 20);
    return value > 1 ? 1 : value;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ClipPath(
      clipBehavior: Clip.hardEdge,
      clipper: CustomAppBar(),
      child: Container(
        height: 55.h + 20,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: const [PRIMARY_YELLOW, PRIMARY_ORANGE],
          ),
        ),
        child: TabBar(
          tabs: tabBar.tabs,
          indicator:
              TriangleTabIndicator(color: Colors.white, radius: 10.w * 0.5),
          indicatorPadding:
              EdgeInsets.only(bottom: 20 * scrollAnimationValue(shrinkOffset)),
          controller: tabBar.controller,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}

class TriangleTabIndicator extends Decoration {
  final BoxPainter _painter;

  TriangleTabIndicator({required Color color, required double radius})
      : _painter = DrawTriangle(color);

  @override
  BoxPainter createBoxPainter([void onChanged]) => _painter;
}

class DrawTriangle extends BoxPainter {
  late final Paint _paint;

  DrawTriangle(Color color) {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final edgeLength = min(11.w, 11.h);
    final Offset triangleOffset = offset +
        Offset(
          configuration.size!.width / 2,
          configuration.size!.height - edgeLength,
        );
    var path = Path();

    path.moveTo(triangleOffset.dx, triangleOffset.dy);
    path.lineTo(triangleOffset.dx + edgeLength, triangleOffset.dy + edgeLength);
    path.lineTo(triangleOffset.dx - edgeLength, triangleOffset.dy + edgeLength);

    path.close();
    canvas.drawPath(path, _paint);
  }
}

class CustomAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height);
    path.arcToPoint(
      Offset(20, size.height - 20),
      radius: const Radius.circular(20),
    );

    path.lineTo(
      size.width - 20,
      size.height - 20,
    );

    path.arcToPoint(
      Offset(size.width, size.height),
      radius: const Radius.circular(20),
    );

    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
