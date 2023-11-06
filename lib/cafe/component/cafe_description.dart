import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/style/default_font_style.dart';

class CafeDescription extends StatelessWidget {
  final String id;
  final String title;
  final String cafeAddress;
  const CafeDescription({
    required this.id,
    required this.title,
    required this.cafeAddress,
    super.key,
  });

  factory CafeDescription.fromModel({
    required CafeDescriptionModel model,
  }) {
    return CafeDescription(
      id: model.id,
      title: model.title,
      cafeAddress: model.cafeAddress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: defaultFontStyleBlack.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
        Text(
          cafeAddress,
          style: defaultFontStyleBlack.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: TEXT_SUBTITLE_COLOR,
          ),
        ),
      ],
    );
  }
}
