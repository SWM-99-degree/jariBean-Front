import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/common/component/pagination_list_view.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/layout/default_card_layout.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/reservation/provider/search_result_provider.dart';
import 'package:jari_bean/reservation/screen/simplified_filter_screen.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';

class SearchResultScreen extends ConsumerWidget {
  static String get routerName => '/search/result';
  const SearchResultScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResult = ref.watch(searchResultProvider);
    final totalCount = searchResult is OffsetPagination<CafeDescriptionModel>
        ? searchResult.content.length
        : 0;
    return DefaultLayout(
      title: "검색 결과",
      child: Column(
        children: [
          SimplifiedFilterScreen(),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 8.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "예약 가능 매장",
                  style: defaultFontStyleBlack.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${totalCount.toString()} ${totalCount < 20 ? '' : '+'}개의 검색 결과',
                  style: defaultFontStyleBlack.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: GRAY_3,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PaginationListView<CafeDescriptionModel>(
              provider: searchResultProvider,
              itemBuilder: (context, ref, index, model) {
                return DefaultCardLayout.fromModel(model: model);
              },
            ),
          ),
        ],
      ),
    );
  }
}
