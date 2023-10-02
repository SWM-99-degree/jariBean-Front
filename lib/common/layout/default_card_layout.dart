import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/cafe/component/cafe_description.dart';
import 'package:jari_bean/cafe/component/cafe_description_with_time.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/cafe/model/cafe_descripton_with_time_left_model.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/history/component/booked_details.dart';
import 'package:jari_bean/history/model/booked_details_model.dart';
import 'package:jari_bean/history/model/matching_model.dart';
import 'package:jari_bean/history/model/reservation_model.dart';

class DefaultCardLayout extends StatelessWidget {
  final String id;
  final String name;
  final String imgUrl;
  final Widget child;
  final Color color;
  final bool isShadowVisible;
  const DefaultCardLayout({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.child,
    this.color = PRIMARY_ORANGE,
    this.isShadowVisible = false,
    super.key,
  });

  factory DefaultCardLayout.fromModel({
    required CafeDescriptionModel model,
  }) {
    if (model is CafeDescriptionWithTimeLeftModel) {
      return DefaultCardLayout(
        id: model.id,
        name: model.title,
        imgUrl: model.imgUrl,
        child: CafeDescriptionWithTimeLeft.fromModel(
          model: model,
        ),
      );
    }
    return DefaultCardLayout(
      id: model.id,
      name: model.title,
      imgUrl: model.imgUrl,
      child: CafeDescription.fromModel(
        model: model,
      ),
    );
  }

  factory DefaultCardLayout.fromReservationModel({
    required ReservationModel model,
  }) {
    return DefaultCardLayout(
      id: model.reservationId,
      name: model.model.title,
      imgUrl: model.model.imgUrl,
      color: Colors.transparent,
      isShadowVisible: true,
      child: buildCafeInfo(
        cafeModel: model.model,
        bookedModel: BookedDetailsModel.fromReservationModel(model: model),
      ),
    );
  }

  factory DefaultCardLayout.fromMatchingModel({
    required MatchingModel model,
  }) {
    return DefaultCardLayout(
      id: model.matchingId,
      name: model.model.title,
      imgUrl: model.model.imgUrl,
      color: Colors.transparent,
      isShadowVisible: true,
      child: buildCafeInfo(
        cafeModel: model.model,
        bookedModel: BookedDetailsModel.fromMatchingModel(model: model),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Container(
          padding: EdgeInsets.all(16.w),
          width: 335.w,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.w, color: color),
              borderRadius: BorderRadius.circular(8),
            ),
            color: Colors.white,
            shadows: [
              if (isShadowVisible)
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 10,
                  offset: Offset(3, 3),
                  spreadRadius: 0,
                )
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imgUrl,
                  width: 84.w,
                  height: 84.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                width: 16.w,
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildCafeInfo({
  required CafeDescriptionModel cafeModel,
  required BookedDetailsModel bookedModel,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        cafeModel.title,
        style: defaultFontStyleBlack.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
      ),
      Text(
        cafeModel.cafeAddress,
        style: defaultFontStyleBlack.copyWith(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: TEXT_SUBTITLE_COLOR,
        ),
      ),
      BookedDetails.fromModel(
        model: bookedModel,
      )
    ],
  );
}
