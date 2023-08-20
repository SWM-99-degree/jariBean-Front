import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jari_bean/cafe/screen/cafe_detail_info_screen.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';

void main() {
  testWidgets('CafeDetailTableScreen has its info', (tester) async {
    await tester.pumpWidget(
      defaultTestableWidgetBuilder(
        CafeDetailInfoScreen(
          cafeId: '123',
          cafeAddress: '부평',
          cafePhoneNumber: '0102814',
          cafeRunTime: '00~24',
          cafeUrl: 'http://google.com',
        ),
      ),
    );

    expect(find.text('부평'), findsOneWidget);
    expect(find.text('00~24'), findsOneWidget);
    expect(find.textContaining('0102814', findRichText: true), findsOneWidget);
    expect(
      find.textContaining('http://google.com', findRichText: true),
      findsOneWidget,
    );
  });
}

Widget defaultTestableWidgetBuilder(Widget widget) {
  return ProviderScope(
    child: ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: DefaultLayout(
            child: widget,
          ),
        ),
      ),
    ),
  );
}
