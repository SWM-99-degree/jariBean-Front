import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/cafe/model/cafe_descripton_with_time_left_model.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/reservation/provider/reservation_timer_provider.dart';

class CafeDescriptionWithTimeLeft extends ConsumerWidget {
  final String id;
  final String title;
  final String cafeAddress;
  const CafeDescriptionWithTimeLeft({
    required this.id,
    required this.title,
    required this.cafeAddress,
    super.key,
  });

  factory CafeDescriptionWithTimeLeft.fromModel({
    required CafeDescriptionWithTimeLeftModel model,
  }) {
    return CafeDescriptionWithTimeLeft(
      id: model.id,
      title: model.title,
      cafeAddress: model.cafeAddress,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeLeft = ref.watch(reservationTimerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: defaultFontStyleBlack.copyWith(
            fontSize: 14.sp,
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
        SizedBox(
          height: 8.h,
        ),
        FilledButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              PRIMARY_YELLOW,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 6.h,
            ),
            child: _buildTimeLeft(timeLeft),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeLeft(int timeLeftInSeconds) {
    if (timeLeftInSeconds == 0) {
      return Text(
        '지금 바로 방문해요!',
        style: defaultFontStyleWhite.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
              text: '방문까지 ',
              style: defaultFontStyleWhite.copyWith(
                fontSize: 12.sp,
              )),
          TextSpan(
            text: _displayTimeLeft(timeLeftInSeconds),
            style: defaultFontStyleWhite.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: ' 남았어요!',
            style: defaultFontStyleWhite.copyWith(
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  String _displayTimeLeft(int timeLeftInSeconds) {
    final dayLeft = timeLeftInSeconds ~/ (24 * 60 * 60);
    final hourLeft = timeLeftInSeconds ~/ (60 * 60) - dayLeft * 24;
    final minuteLeft =
        timeLeftInSeconds ~/ 60 - dayLeft * 24 * 60 - hourLeft * 60;
    final secondLeft = timeLeftInSeconds % 60;

    String ret = '';

    if (dayLeft > 0) {
      return dayLeft > 0 ? '$dayLeft일 ' : '';
    } else if (hourLeft > 0) {
      ret += '$hourLeft시간';
      ret += minuteLeft > 0 ? '$minuteLeft분' : '';
      return ret;
    } else {
      ret += minuteLeft > 0 ? '$minuteLeft분' : '';
      ret += secondLeft > 0 ? '$secondLeft초' : '';
      return ret;
    }
  }
}
