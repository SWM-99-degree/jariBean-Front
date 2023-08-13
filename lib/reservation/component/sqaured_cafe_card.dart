import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/reservation/model/cafe_description_with_rating_model.dart';

class SquaredCafeCard extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;
  final String cafeAddress;
  final double rating;

  const SquaredCafeCard({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.cafeAddress,
    required this.rating,
    super.key,
  });

  factory SquaredCafeCard.fromModel({
    required CafeDescriptionWithRatingModel model,
  }) {
    return SquaredCafeCard(
      id: model.id,
      title: model.title,
      imgUrl: model.imgUrl,
      cafeAddress: model.cafeAddress,
      rating: model.rating,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              imgUrl,
              width: 120.w,
              height: 120.w,
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            title,
            style: defaultFontStyleBlack.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              Text(
                rating.toString(),
                style: defaultFontStyleBlack.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 4.w,
              ),
              Text(
                cafeAddress,
                style: defaultFontStyleBlack.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: TEXT_SUBTITLE_COLOR,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
