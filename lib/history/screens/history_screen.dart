import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/layout/default_card_layout.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:jari_bean/history/provider/matching_history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  static String get routerName => '/history';
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchingModelBundles = ref.watch(matchingBundlesProvider);
    return ListView.builder(
      itemCount: matchingModelBundles.length,
      itemBuilder: (_, index) {
        final curBundle = matchingModelBundles[index];
        final date = curBundle.date;
        final models = curBundle.models;
        return Column(
          children: [
            _buildDateDiscriminator(date),
            SizedBox(height: 8.h),
            ...models.map(
              (model) => DefaultCardLayout.fromHistoryModel(model: model),
            ),
            SizedBox(height: 12.h)
          ],
        );
      },
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
