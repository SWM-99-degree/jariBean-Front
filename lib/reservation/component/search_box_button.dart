import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/reservation/layout/default_search_box_layout.dart';

class SearchBoxButton extends StatelessWidget {
  final String hintText;
  final Function()? onPressed;

  const SearchBoxButton({
    required this.hintText,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultSearchBoxLayout(
      onPressed: onPressed,
      children: [
        Text(
          hintText,
          style: defaultFontStyleBlack.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: GRAY_3,
          ),
        ),
      ],
    );
  }
}
