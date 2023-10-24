import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/cafe/component/cafe_description.dart';
import 'package:jari_bean/cafe/component/cafe_description_with_time.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/cafe/model/cafe_descripton_with_time_left_model.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/history/component/booked_details.dart';
import 'package:jari_bean/history/model/booked_details_model.dart';
import 'package:jari_bean/history/model/history_model.dart';
import 'package:skeletons/skeletons.dart';

class DefaultCardLayout extends StatelessWidget {
  final String id;
  final String name;
  final String? imgUrl;
  final Widget child;
  final Color borderColor;
  final bool isShadowVisible;
  final VoidCallback? onTap;
  final String? routerPath;
  final bool isDisabled;
  const DefaultCardLayout({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.child,
    this.borderColor = PRIMARY_ORANGE,
    this.isShadowVisible = false,
    this.onTap,
    this.routerPath,
    this.isDisabled = false,
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
        routerPath: '/cafe/${model.id}',
        child: CafeDescriptionWithTimeLeft.fromModel(
          model: model,
        ),
      );
    }
    return DefaultCardLayout(
      id: model.id,
      name: model.title,
      imgUrl: model.imgUrl,
      routerPath: '/cafe/${model.id}',
      child: CafeDescription.fromModel(
        model: model,
      ),
    );
  }

  factory DefaultCardLayout.fromTodayReservationModel({
    required ReservationModelBase model,
  }) {
    if (model is ReservationModel) {
      return DefaultCardLayout(
        id: model.id,
        name: model.model.title,
        imgUrl: model.model.imgUrl,
        borderColor: Colors.transparent,
        isShadowVisible: true,
        routerPath: '/cafe/${model.model.id}',
        child: buildCafeInfo(
          cafeModel: model.model,
          bookedModel: BookedDetailsModel.fromReservationModel(model: model),
        ),
      );
    } else if (model is ResrevationModelError) {
      return DefaultCardLayout(
        id: 'error',
        name: 'error',
        imgUrl: 'error',
        borderColor: Colors.transparent,
        isShadowVisible: true,
        child: Text(model.message),
      );
    }
    return DefaultCardLayout(
      id: 'loading',
      name: 'loading',
      imgUrl: 'loading',
      borderColor: Colors.transparent,
      isShadowVisible: true,
      child: buildSkeleton(),
    );
  }

  factory DefaultCardLayout.fromHistoryModel({
    required IHistoryModelBase model,
  }) {
    return DefaultCardLayout(
      id: model.id,
      name: model.model.title,
      imgUrl: model.model.imgUrl,
      borderColor: Colors.transparent,
      isShadowVisible: true,
      routerPath: '/cafe/${model.model.id}',
      child: buildCafeInfo(
        cafeModel: model.model,
        bookedModel: BookedDetailsModel.fromHistoryModel(model: model),
      ),
    );
  }

  factory DefaultCardLayout.preloading() {
    return DefaultCardLayout(
      id: 'loading',
      name: 'loading',
      imgUrl: 'loading',
      borderColor: Colors.transparent,
      isShadowVisible: true,
      child: buildSkeleton(),
    );
  }

  copyWith({
    String? id,
    String? name,
    String? imgUrl,
    Widget? child,
    Color? borderColor,
    bool? isShadowVisible,
    VoidCallback? onTap,
    String? routerPath,
    bool? isDisabled,
  }) {
    return DefaultCardLayout(
      id: id ?? this.id,
      name: name ?? this.name,
      imgUrl: imgUrl ?? this.imgUrl,
      borderColor: borderColor ?? this.borderColor,
      isShadowVisible: isShadowVisible ?? this.isShadowVisible,
      onTap: onTap ?? this.onTap,
      routerPath: routerPath ?? this.routerPath,
      isDisabled: isDisabled ?? this.isDisabled,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    late final Function() onTap;
    if (routerPath == null) {
      onTap = this.onTap ?? () => {};
    } else {
      onTap = () => {context.push(routerPath!)};
    }
    return Center(
      child: GestureDetector(
        onTap: this.onTap ?? onTap,
        child: Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: Container(
            padding: EdgeInsets.all(16.w),
            width: 335.w,
            foregroundDecoration: isDisabled
                ? BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    backgroundBlendMode: BlendMode.saturation,
                  )
                : null,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1.w, color: borderColor),
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
                  ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Skeleton(
                    isLoading: id == 'loading',
                    skeleton: SkeletonAvatar(
                      style: SkeletonAvatarStyle(
                        width: 84.w,
                        height: 84.w,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Image.network(
                      imgUrl ??
                          'https://picsum.photos/200/300', // Todo: change to default image
                      width: 84.w,
                      height: 84.w,
                      fit: BoxFit.cover,
                      frameBuilder:
                          (context, child, frame, wasSynchronouslyLoaded) {
                        return Skeleton(
                          isLoading: frame == null,
                          skeleton: SkeletonAvatar(
                            style: SkeletonAvatarStyle(
                              width: 84.w,
                              height: 84.w,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: child,
                        );
                      },
                    ),
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
      ),
    ],
  );
}

Widget buildSkeleton() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SkeletonLine(
        style: SkeletonLineStyle(
          height: 16.h,
          width: 200.w,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      SizedBox(
        height: 8.h,
      ),
      SkeletonLine(
        style: SkeletonLineStyle(
          height: 16.h,
          width: 100.w,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      SizedBox(
        height: 12.h,
      ),
      SkeletonLine(
        style: SkeletonLineStyle(
          height: 24.h,
          width: 100.w,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );
}
