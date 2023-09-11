import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/matching/provider/matching_provider.dart';

class MatchingHomeScreen extends ConsumerWidget {
  const MatchingHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchingHeadcount = ref.watch(matchingHeadcountProvider);
    return ListView(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      children: [
        SizedBox(
          height: 40.h,
        ),
        Icon(JariBeanIconPack.matching, size: 52.w, color: PRIMARY_ORANGE),
        SizedBox(
          height: 8.h,
        ),
        Text(
          '인원 선택',
          textAlign: TextAlign.center,
          style: defaultFontStyleBlack.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 40.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildCircularButton(
                onpressed: () {
                  ref.read(matchingHeadcountProvider.notifier).decrement();
                },
                icon: Icon(
                  Icons.remove,
                  size: 24.w,
                  color: Colors.black,
                ),
              ),
              Text(
                matchingHeadcount.toString(),
                textAlign: TextAlign.center,
                style: defaultFontStyleBlack.copyWith(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _buildCircularButton(
                onpressed: () {
                  ref.read(matchingHeadcountProvider.notifier).increment();
                },
                icon: Icon(
                  Icons.add,
                  size: 24.w,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 32.h,
        ),
        Container(
          width: 335.w,
          height: 82.h,
          decoration: ShapeDecoration(
            color: Color(0xFFF8F8F8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '2명',
                    style: defaultFontStyleBlack.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: PRIMARY_ORANGE,
                    ),
                  ),
                  TextSpan(
                    text: '이서 사용 가능한 자리가 있는\n도보 기준 10분 거리의 매장을 찾아 드려요',
                    style: defaultFontStyleBlack.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: TEXT_SUBTITLE_COLOR,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        CustomButton(
          text: '매칭하기',
          onPressed: () {
            context.go('/matching/proceeding');
          },
        ),
      ],
    );
  }

  Widget _buildCircularButton({
    required Function() onpressed,
    required Icon icon,
  }) {
    return ElevatedButton(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(56.w, 56.w),
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
        side: BorderSide(
          width: 1.5.sp,
          strokeAlign: BorderSide.strokeAlignCenter,
          color: Color(0xFFCCCCCC),
        ),
      ),
      child: icon,
    );
  }
}
