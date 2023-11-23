import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/component/custom_dialog.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/common/models/custom_button_model.dart';
import 'package:jari_bean/common/models/custom_dialog_model.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/matching/provider/matching_provider.dart';
import 'package:jari_bean/matching/screen/kakao_map_view.dart';

class MatchingProceedingScreen extends ConsumerStatefulWidget {
  const MatchingProceedingScreen({super.key});

  @override
  ConsumerState<MatchingProceedingScreen> createState() =>
      _MatchingProceedingScreenState();
}

class _MatchingProceedingScreenState
    extends ConsumerState<MatchingProceedingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '매칭중',
      child: Stack(
        children: [
          KakaoMapView(),
          Positioned(
            bottom: 0,
            child: Container(
              height: 218.h,
              width: 375.w,
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 32.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                shadows: const [
                  BoxShadow(
                    color: Color(0x0C995B24),
                    blurRadius: 10,
                    offset: Offset(0, -6),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 84.w,
                        height: 84.w,
                        decoration: ShapeDecoration(
                          color: Color(0xFFF2F2F2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '매칭중...',
                            style: defaultFontStyleBlack.copyWith(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            '도보 기준 10분 내 이동 가능한 매장 찾는중',
                            style: defaultFontStyleBlack.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: TEXT_SUBTITLE_COLOR,
                            ),
                          ),
                          Text(
                            '2명 · 고려대역',
                            style: defaultFontStyleBlack.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: CustomButton(
                      text: '매칭취소',
                      onPressed: () => showCustomDialog(
                        context: context,
                        model: CustomDialogWithTwoButtonsModel(
                          title: '매칭 취소',
                          description: '매칭을 취소할까요?',
                          customButtonModel: CustomButtonModel(
                            title: '아니요',
                            onPressed: () {
                              context.pop();
                            },
                            isDismiss: true,
                          ),
                          customButtonModelSecond: CustomButtonModel(
                            title: '네',
                            onPressed: () {
                              context.pop();
                              ref
                                  .read(matchingProvider.notifier)
                                  .cancelMatchingInEnqueued(
                                    () => context.pop(),
                                  );
                            },
                          ),
                        ),
                      )(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
