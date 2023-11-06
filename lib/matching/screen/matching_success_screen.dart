import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/layout/default_card_layout.dart';
import 'package:jari_bean/common/models/custom_button_model.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:jari_bean/matching/provider/matching_timer_provider.dart';

class MatchingSuccessScreen extends ConsumerWidget {
  const MatchingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              DefaultCardLayout.fromModel(
                model: CafeDescriptionModel.fromJson({
                  'cafeId': '1',
                  'cafeName': '스타벅스 고대점',
                  'cafeAddress': '서울특별시 성북구 고려대로 24실 51',
                  'cafeImageUrl': 'https://picsum.photos/250?image=9',
                }),
              ),
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
                          ref
                              .read(matchingTimerProvider.notifier)
                              .initTimer(initTimeLeft: 600);
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
