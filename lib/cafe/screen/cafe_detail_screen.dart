import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/cafe/screen/cafe_detail_info_screen.dart';
import 'package:jari_bean/cafe/screen/cafe_detail_table_screen.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/common/style/default_font_style.dart';

class CafeDetailScreen extends StatefulWidget {
  final String cafeId;

  const CafeDetailScreen({
    required this.cafeId,
    super.key,
  });

  @override
  State<CafeDetailScreen> createState() => _CafeDetailScreenState();
}

class _CafeDetailScreenState extends State<CafeDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _scrollController.addListener(() {
      if (_scrollController.offset > 400) {
        if (!_tabController.indexIsChanging) {
          _tabController.animateTo(1);
          setState(() {});
        }
      } else {
        if (!_tabController.indexIsChanging) {
          _tabController.animateTo(0);
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'GRAZ Coffee 강남',
      child: DefaultTabController(
        length: 2,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 400,
              toolbarHeight: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  'https://picsum.photos/400/600',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: TabBarDelegate(
                controller: _tabController,
                update: (int index) {
                  if (!_tabController.indexIsChanging) {
                    if (index == 0) {
                      _scrollController.animateTo(
                        0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      _tabController.animateTo(0);
                    } else {
                      _scrollController.animateTo(
                        400,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      _tabController.animateTo(1);
                    }
                  }
                  setState(() {});
                },
              ),
              pinned: true,
            ),
            SliverFillRemaining(
              // 탭바 뷰 내부에는 스크롤이 되는 위젯이 들어옴.
              hasScrollBody: true,
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  CafeDetailInfoScreen(
                    cafeId: '123',
                    cafeAddress: '서울 성동구 고산자로 234(우) 04744',
                    cafePhoneNumber: '1522-3232',
                    cafeRunTime: '월~목 07:00 ~ 22:00',
                    cafeUrl: 'www.starbucks.co.kr',
                  ),
                  CafeDetailTableScreen(cafeId: widget.cafeId)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController controller;
  final Function(int) update;
  const TabBarDelegate({
    required this.update,
    required this.controller,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: controller,
        tabs: [
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: TextButton(
                onPressed: () {
                  update(0);
                },
                child: Text(
                  "카페정보",
                  style: defaultFontStyleBlack.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: controller.index == 0
                        ? Colors.black
                        : TEXT_SUBTITLE_COLOR,
                  ),
                ),
              ),
            ),
          ),
          Tab(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white,
              child: TextButton(
                onPressed: () {
                  update(1);
                },
                child: Text(
                  "테이블",
                  style: defaultFontStyleBlack.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: controller.index == 1
                        ? Colors.black
                        : TEXT_SUBTITLE_COLOR,
                  ),
                ),
              ),
            ),
          ),
        ],
        indicatorWeight: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        unselectedLabelColor: Colors.grey,
        labelColor: Colors.black,
        indicatorColor: Colors.black,
        indicatorSize: TabBarIndicatorSize.label,
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    oldDelegate as TabBarDelegate;
    if (oldDelegate.controller.index != controller.index) {
      return true;
    }
    return false;
  }
}
