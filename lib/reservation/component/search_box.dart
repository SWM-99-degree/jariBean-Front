import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/reservation/layout/default_search_box_layout.dart';
import 'package:jari_bean/reservation/provider/search_text_provider.dart';

class SearchBox extends ConsumerWidget {
  final String hintText;
  final String? searchArea;

  const SearchBox({
    required this.hintText,
    this.searchArea,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultSearchBoxLayout(
      onPressed: null,
      children: [
        Text(
          searchArea != null ? '${searchArea!}｜' : '',
          style: defaultFontStyleBlack.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            cursorColor: GRAY_3,
            style: defaultFontStyleBlack.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            onChanged: (value) {
              ref.read(searchTextProvider.notifier).searchText = value;
            },
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: defaultFontStyleBlack.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: GRAY_3,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusColor: Colors.transparent,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}
