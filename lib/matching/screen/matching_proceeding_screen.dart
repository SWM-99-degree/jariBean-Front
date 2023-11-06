import 'dart:math';

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
    Future.delayed(
      Duration(seconds: 3),
      Random().nextBool()
          ? () => context.push('/matching/success')
          : showCustomDialog(
              context: context,
              model: CustomDialogWithTwoButtonsModel(
                title: '매칭 실패',
                description: '같은조건으로 매칭을 다시 시도해 볼까요?.',
                customButtonModel:
                    CustomButtonModel(title: '취소', isDismiss: true),
                customButtonModelSecond: CustomButtonModel(
                  title: '취소',
                  onPressed: () {
                    context.go('/matching/home');
                  },
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '매칭중',
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  'https://s3-alpha-sig.figma.com/img/cac3/1d9a/82f55aab992954a68fd865e6ae95c8f2?Expires=1693785600&Signature=FmHe-6HGLQadGLHJ5o0K-VquKQuEW9U5x68wDQcmC-g1BO5dNa8ej4mc6s2-SNaOySaWMfD2EDN6ZPdbzR4Xpxud6K8HHHZsZHbe7yHIPkt7dIFm141OvgEX0ct3jwTUu11CxFzcX6MUXNll2UvpQbFab6F7J75Kc13nHJaG5I3qzP31ymJgDYGaYPZYx6Rs9qjzk7qHbnZ18YN3L6iThCo2-cnMPTDVnpeFocfR5CNLwD66XKFZyZs3qg0CGLJaeDSGa8LfN3pK9Aq14ydgOFb3UndZbBdbiA2TZBmYt4NYTO3alWUIYmfv1IwKd4xUTV0Ws9icA7R44wjM67uWVQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Text('매칭중'),
            ),
          ),
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
                            '도보 기준 10내 이동 가능한 매장 찾는중',
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
                      onPressed: () {
                        showCustomDialog(
                          context: context,
                          model: CustomDialogWithTwoButtonsModel(
                            title: '매칭 실패',
                            description: '같은조건으로 매칭을 다시 시도해 볼까요?.',
                            customButtonModel: CustomButtonModel(
                              title: '다시 시도',
                              onPressed: () {
                                context.go('/matching/home');
                              },
                            ),
                            customButtonModelSecond: CustomButtonModel(
                              title: '취소',
                              onPressed: () {
                                context.go('/matching/home');
                              },
                            ),
                          ),
                        );
                      },
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
