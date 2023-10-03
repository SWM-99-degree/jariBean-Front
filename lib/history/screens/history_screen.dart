import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/layout/default_card_layout.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:jari_bean/history/provider/matching_history_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  static String get routerName => '/history';
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<String> _tabs = ['예약', '매칭'];

  @override
  void initState() {
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: 0,
    );
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matchingModelBundles = ref.watch(matchingBundlesProvider);
    final todayModel = ref.watch(matchingHistoryProvider).first;
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            leading: SizedBox(),
            expandedHeight: 228.h,
            collapsedHeight: 228.h,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(top: 20.w, left: 16.h, right: 16.h),
                    color: PRIMARY_YELLOW,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        Text(
                          '오늘 나의 자리',
                          style: defaultFontStyleWhite.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            height: 0.09.h,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        DefaultCardLayout.fromHistoryModel(model: todayModel),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                  Container(
                    height: 40.h,
                    width: 375.w,
                    color: PRIMARY_YELLOW,
                    child: Container(
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                      ),
                      padding: EdgeInsets.only(top: 20.h, left: 16.h),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '방문 내역',
                          style: defaultFontStyleBlack.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            height: 0.09.h,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            backgroundColor: Colors.white,
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
                      (e) => Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Tab(
                            child: Stack(
                              children: [
                                Text(
                                  e.value,
                                  style: defaultFontStyleWhite.copyWith(
                                    color: e.key == _tabController.index
                                        ? PRIMARY_ORANGE
                                        : GRAY_3,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14.sp,
                                    height: 0.13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
        body: ListView.builder(
          itemCount: matchingModelBundles.length,
          itemBuilder: (_, index) {
            final curBundle = matchingModelBundles[index];
            final date = curBundle.date;
            final models = curBundle.models;
            return Column(
              children: [
                SizedBox(height: 12.h),
                _buildDateDiscriminator(date),
                SizedBox(height: 8.h),
                ...models.map(
                  (model) => DefaultCardLayout.fromHistoryModel(model: model),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _buildDateDiscriminator(DateTime date) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          color: GRAY_1,
          height: 2,
        ),
        Center(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              Utils.getYYYYMMDDfromDateTime(date),
              style: defaultFontStyleWhite.copyWith(
                fontSize: 12.sp,
                color: GRAY_3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => 55.h;

  @override
  double get maxExtent => 55.h;

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
    return Container(
      height: 55.h,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              height: 2.h,
              width: 375.w,
              color: GRAY_3,
            ),
          ),
          TabBar(
            tabs: tabBar.tabs,
            indicatorWeight: 2.h,
            indicatorColor: PRIMARY_ORANGE,
            controller: tabBar.controller,
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
