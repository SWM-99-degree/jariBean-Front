import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/layout/default_card_layout.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/common/models/custom_button_model.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/matching/provider/matching_timer_provider.dart';

class MatchingSuccessScreen extends ConsumerWidget {
  const MatchingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeLeftInSeconds = ref.watch(matchingTimerProvider);
    return DefaultLayout(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.86, -0.52),
            end: Alignment(-0.86, 0.52),
            colors: const [PRIMARY_YELLOW, PRIMARY_ORANGE],
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 176.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Icon(
                    JariBeanIconPack.ok_sign,
                    size: 52.w,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    '매칭 성공',
                    textAlign: TextAlign.center,
                    style: defaultFontStyleWhite.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
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
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
