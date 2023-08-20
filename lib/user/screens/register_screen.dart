import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/component/custom_checkbox_tile.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/user/provider/registration_provider.dart';
import 'package:jari_bean/user/provider/user_provider.dart';

class RegisterScreen extends ConsumerWidget {
  static String get routerName => '/register';
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agreements = ref.watch(totalAgreementProvider);
    return WillPopScope(
      child: DefaultLayout(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '회원가입',
                  style: defaultFontStyleBlack.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '안녕하세요,\n자리빈에 오신것을 환영합니다!',
                      style: defaultFontStyleBlack.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      '자리빈의 원활한 이용을 위해\n아래의 약관 동의가 필요합니다.',
                      style: defaultFontStyleBlack.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: TEXT_SUBTITLE_COLOR,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: CustomCheckboxTile(
                        title: '약관 전체 동의',
                        description: '약관 전체 동의',
                        isChecked: ref
                            .watch(totalAgreementProvider.notifier)
                            .isAllAgreed,
                        onChanged: (value) {
                          if (ref
                              .read(totalAgreementProvider.notifier)
                              .isAllAgreed) {
                            ref
                                .read(totalAgreementProvider.notifier)
                                .disagreeNotMandatory();
                            return;
                          }
                          ref.read(totalAgreementProvider.notifier).agreeAll();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: Divider(color: GRAY_2, thickness: 1.0.h),
                    ),
                    for (int i = 0; i < agreements.length; i++)
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: CustomCheckboxTile(
                          title: agreements[i].title,
                          description: agreements[i].description,
                          isChecked: agreements[i].isAgreed,
                          onChanged: (value) {
                            ref
                                .read(totalAgreementProvider.notifier)
                                .toggleAgreement(i);
                          },
                        ),
                      ),
                    SizedBox(
                      height: 36.h,
                    ),
                    CustomButton(
                      text:
                          ref.watch(totalAgreementProvider.notifier).buttonText,
                      onPressed: () async {
                        if (!ref
                            .read(totalAgreementProvider.notifier)
                            .isAllMandatoryAgreed) {
                          ref.read(totalAgreementProvider.notifier).agreeAll();
                          return;
                        }

                        ref.read(userProvider.notifier).register();
                        context.go('/alert');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
