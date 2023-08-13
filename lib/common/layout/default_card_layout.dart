import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/cafe/component/cafe_description_with_time.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/cafe/model/cafe_descripton_with_time_left_model.dart';
import 'package:jari_bean/common/const/color.dart';

class DefaultCardLayout extends StatelessWidget {
  final String id;
  final String name;
  final String imgUrl;
  final Widget child;
  const DefaultCardLayout({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.child,
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
        child: Text('미구현'));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 8.h),
        child: Container(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            top: 16.h,
            bottom: 16.h,
          ),
          width: 335.w,
          height: 116.h,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.w, color: PRIMARY_ORANGE),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imgUrl,
                  width: 84.w,
                  height: 84.w,
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
