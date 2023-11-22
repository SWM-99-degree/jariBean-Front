import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/cafe/provider/cafe_provider.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/exception/custom_exception.dart';
import 'package:jari_bean/common/layout/default_card_layout.dart';
import 'package:jari_bean/common/models/custom_button_model.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:jari_bean/matching/provider/matching_timer_provider.dart';

class MatchingSuccessScreen extends ConsumerWidget {
  const MatchingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchingInfo = ref.watch(matchingInfoProvider);
    if (matchingInfo == null) {
      return const Text('잘못된 접근입니다.');
    }
    final cafe =
        ref.watch(simplifiedCafeInformationProvider(matchingInfo.cafeId));
    final timeLeftInSeconds = ref.watch(matchingTimerProvider);
    return ListView(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              DefaultCardLayout.fromModel(model: cafe),
              SizedBox(
                height: 24.h,
              ),
              Text(
                '체크인 타이머',
                style: defaultFontStyleBlack.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              _percentageBuilder(timeLeftInSeconds),
              SizedBox(
                height: 32.h,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomButton.fromModel(
                      model: CustomButtonModel(
                        title: '매칭취소',
                        onPressed: () {},
                        isDisabled: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Expanded(
                    child: CustomButton.fromModel(
                      model: CustomButtonModel(
                        title: '길찾기',
                        onPressed: () {
                          throw UnimplementedException();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _percentageBuilder(int timeLeftInSeconds) {
    // ignore: constant_identifier_names
    const TWO_PI = 3.14 * 2;

    double value = 1 - (timeLeftInSeconds / 600);
    return Container(
      width: 200.w,
      height: 200.w,
      color: Colors.white,
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return SweepGradient(
                startAngle: 0.0,
                endAngle: TWO_PI,
                stops: const [0, 0.5, 1.0],
                center: Alignment.center,
                colors: const [
                  PRIMARY_YELLOW,
                  PRIMARY_ORANGE,
                  PRIMARY_YELLOW,
                ],
                transform: GradientRotation(-TWO_PI / 4),
              ).createShader(rect);
            },
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          ShaderMask(
            shaderCallback: (rect) {
              return SweepGradient(
                startAngle: 0.0,
                endAngle: TWO_PI,
                stops: [value, 0],
                center: Alignment.center,
                colors: const [
                  Colors.white,
                  Colors.transparent,
                ],
                transform: GradientRotation(-TWO_PI / 4),
              ).createShader(rect);
            },
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF2F2F2),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 175.w,
              height: 175.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  Utils.getMMSSfromDateSeconds(timeLeftInSeconds),
                  style: defaultFontStyleBlack.copyWith(
                    fontSize: 32.sp,
                    color: PRIMARY_ORANGE,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
