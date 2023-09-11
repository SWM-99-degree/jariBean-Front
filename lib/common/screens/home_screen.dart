import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/matching/provider/matching_timer_provider.dart';
import 'package:jari_bean/matching/screen/matching_home_screen.dart';
import 'package:jari_bean/matching/screen/matching_success_screen.dart';
import 'package:jari_bean/reservation/screen/reservation_home_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController =
      ScrollController(initialScrollOffset: 50.h);
  late final TabController _tabController;

  bool flag = false;

  final List<String> _tabs = ['자리 예약하기', '실시간 매칭하기'];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {});
      if (_tabController.indexIsChanging) {
        _scrollController.animateTo(
          ((flag && _tabController.index == 0) ? 176.h : 0) + 50.h,
          duration: Duration(milliseconds: flag ? 250 : 150),
          curve: Curves.easeInOut,
        );
      }
    });
    _scrollController.addListener(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    flag = ref.watch(matchingInfoProvider);
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, _) => [
          SliverAppBar(
            toolbarHeight: (flag) ? 176.h : 0,
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
                indicator:
                    TriangleTabIndicator(color: Colors.white, radius: 10),
                indicatorPadding: EdgeInsets.only(bottom: 20),
                controller: _tabController,
                tabs: _tabs
                    .map(
                      (String name) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Tab(
                              child: Text(
                                name,
                                style: defaultFontStyleWhite.copyWith(
                                  color: Colors.white.withOpacity(
                                    _tabController.index == _tabs.indexOf(name)
                                        ? 1
                                        : 0.5,
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
            child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                ReservationHomeScreen(),
                flag ? MatchingSuccessScreen() : MatchingHomeScreen()
              ],
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
          controller: tabBar.controller,
          indicator:
              TriangleTabIndicator(color: Colors.white, radius: 10.w * 0.5),
          indicatorPadding:
              EdgeInsets.only(bottom: 20 * scrollAnimationValue(shrinkOffset)),
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
