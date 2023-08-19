import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/cafe/model/cafe_descripton_with_time_left_model.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/layout/default_card_layout.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/reservation/component/circled_location_button.dart';
import 'package:jari_bean/reservation/component/search_box.dart';
import 'package:jari_bean/reservation/component/sqaured_cafe_card.dart';
import 'package:jari_bean/reservation/model/cafe_description_with_rating_model.dart';
import 'package:jari_bean/reservation/model/service_area_model.dart';
import 'package:jari_bean/reservation/provider/urgent_reservation_provider.dart';
import 'package:jari_bean/user/models/user_model.dart';
import 'package:jari_bean/user/provider/user_provider.dart';

class ReservationHomeScreen extends ConsumerWidget {
  const ReservationHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider) as UserModel;
    final serviceAreas = [
      ServiceAreaModel(
          id: '234234', name: '고려대', imgUrl: 'https://picsum.photos/250?id=1'),
      ServiceAreaModel(
          id: '234234', name: '고려대', imgUrl: 'https://picsum.photos/250?id=2'),
      ServiceAreaModel(
          id: '234234', name: '고려대', imgUrl: 'https://picsum.photos/250?id=3'),
      ServiceAreaModel(
          id: '234234', name: '고려대', imgUrl: 'https://picsum.photos/250?id=4'),
      ServiceAreaModel(
          id: '234234', name: '고려대', imgUrl: 'https://picsum.photos/250?id=5'),
      ServiceAreaModel(
          id: '234234', name: '고려대', imgUrl: 'https://picsum.photos/250?id=6'),
      ServiceAreaModel(
          id: '234234', name: '고려대', imgUrl: 'https://picsum.photos/250?id=7'),
    ];
    // final urgentReservation = CafeDescriptionWithTimeLeftModel(
    //   id: '123123',
    //   title: '스타벅스 고대점',
    //   cafeAddress: '서울특별시 성북구 고려대로 24길 51',
    //   timeLeft: Random().nextInt(86400),
    //   imgUrl: 'https://picsum.photos/250',
    // );
    final user = ref.watch(userProvider);
    if (user is! UserModel) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    final userModel = user;

    final urgentReservation = ref.watch(urgentReservationProvider);
    final hotplaceCafes = [
      CafeDescriptionWithRatingModel(
        id: '234234',
        title: '트러스트 홍대점',
        imgUrl: 'https://picsum.photos/250?id=1',
        cafeAddress: '서울 마포구',
        rating: 4.5,
      ),
      CafeDescriptionWithRatingModel(
        id: '234234',
        title: '트러스트 홍대점',
        imgUrl: 'https://picsum.photos/250?id=2',
        cafeAddress: '서울 마포구',
        rating: 4.5,
      ),
      CafeDescriptionWithRatingModel(
        id: '234234',
        title: '트러스트 홍대점',
        imgUrl: 'https://picsum.photos/250?id=3',
        cafeAddress: '서울 마포구',
        rating: 4.5,
      ),
    ];

    return ListView(children: [
      SizedBox(
        height: 20.h,
      ),
      SearchBox(
        hintText: '지역, 카페명 검색',
        onChanged: (value) {},
        readOnly: true,
      ),
      SizedBox(
        height: 24.h,
      ),
      _buildTextDisplay(
        title: '자리 예약 하기',
        description: '장소를 기준으로 카페를 찾을 수 있어요',
      ),
      Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: SizedBox(
          height: 60.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20.w),
            shrinkWrap: true,
            itemCount: serviceAreas.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: CircledLocationButtonWithIcon(),
                );
              }
              return Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: CircledLocationButton.fromModel(
                  model: serviceAreas[index - 1],
                ),
              );
            },
          ),
        ),
      ),
      SizedBox(
        height: 32.h,
      ),
      _buildTextDisplay(
        title: '예약 내역',
        description: '${userModel.nickname}님의 예약 내역을 볼 수 있어요',
        infoTitle: '전체보기',
      ),
      SizedBox(
        height: 8.h,
      ),
      if (urgentReservation is CafeDescriptionWithTimeLeftModel)
        DefaultCardLayout.fromModel(
          model: urgentReservation,
        ),
      SizedBox(
        height: 32.h,
      ),
      _buildTextDisplay(
        title: '예약 핫플레이스 BEST',
        description: '지금 핫한 카페를 볼 수 있어요',
        infoTitle: '전체보기',
      ),
      Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(left: 20.w),
            shrinkWrap: true,
            itemCount: hotplaceCafes.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: SquaredCafeCard.fromModel(
                  model: hotplaceCafes[index],
                ),
              );
            },
          ),
        ),
      ),
    ]);
  }

  Widget _buildTextDisplay(
      {required String title, required String description, String? infoTitle}) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.left,
                style: defaultFontStyleBlack.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                description,
                textAlign: TextAlign.left,
                style: defaultFontStyleBlack.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: TEXT_SUBTITLE_COLOR,
                ),
              )
            ],
          ),
          if (infoTitle != null)
            Row(
              children: [
                Text(
                  infoTitle,
                  style: defaultFontStyleBlack.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.24,
                    color: TEXT_SUBTITLE_COLOR,
                  ),
                ),
                Icon(
                  JariBeanIconPack.arrow_right,
                  size: 16.sp,
                )
              ],
            )
        ],
      ),
    );
  }
}
