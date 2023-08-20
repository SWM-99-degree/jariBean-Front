import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/style/default_font_style.dart';

class CafeDetailInfoScreen extends StatelessWidget {
  final String cafeId;
  final String cafeAddress;
  final String cafeRunTime;
  final String cafeUrl;
  final String cafePhoneNumber;
  const CafeDetailInfoScreen({
    required this.cafeId,
    required this.cafeAddress,
    required this.cafeRunTime,
    required this.cafeUrl,
    required this.cafePhoneNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 32.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIconAndText(
            icon: JariBeanIconPack.gps,
            textSpan: TextSpan(
              text: cafeAddress,
              style: defaultFontStyleBlack.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Text(
              cafeAddress,
              style: defaultFontStyleBlack.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: TEXT_SUBTITLE_COLOR,
              ),
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          _buildIconAndText(
            icon: Icons.access_time,
            textSpan: TextSpan(
              text: '영업중',
              style: defaultFontStyleBlack.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3CCA54),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.w),
            child: Text(
              cafeRunTime,
              style: defaultFontStyleBlack.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          _buildIconAndText(
            icon: Icons.link,
            textSpan: TextSpan(
              text: cafeUrl,
              style: defaultFontStyleBlack.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3F85F7),
              ),
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          _buildIconAndText(
            icon: Icons.phone,
            textSpan: TextSpan(
              text: cafePhoneNumber,
              style: defaultFontStyleBlack.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3F85F7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconAndText({
    required IconData icon,
    required TextSpan textSpan,
  }) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              icon,
              size: 16.w,
              color: TEXT_SUBTITLE_COLOR,
            ),
          ),
          WidgetSpan(
            child: SizedBox(
              width: 8.w,
            ),
          ),
          textSpan,
        ],
      ),
    );
  }
}
