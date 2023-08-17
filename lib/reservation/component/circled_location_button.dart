import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/reservation/model/service_area_model.dart';

class CircledLocationButton extends StatelessWidget {
  final String serivceAreaId;
  final String serivceAreaName;
  final String imgUrl;
  const CircledLocationButton(
      {required this.serivceAreaId,
      required this.serivceAreaName,
      required this.imgUrl,
      super.key});

  factory CircledLocationButton.fromModel({
    required ServiceAreaModel model,
  }) {
    return CircledLocationButton(
      serivceAreaId: model.id,
      serivceAreaName: model.name,
      imgUrl: model.imgUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {},
        child: Ink(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(imgUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Text(
              serivceAreaName,
              style: defaultFontStyleWhite.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CircledLocationButtonWithIcon extends StatelessWidget {
  const CircledLocationButtonWithIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // elvated button with photo inside, make it circle

    return GestureDetector(
      onTap: () {},
      child: Stack(
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: ShapeDecoration(
              color: Color(0xFFFF9D46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Positioned(
            left: 15.5.w,
            top: 36.w,
            child: Text(
              '내 주변',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w800,
                height: 1.50,
              ),
            ),
          ),
          Positioned(
            left: 18.w,
            top: 11.w,
            child: SizedBox(
              width: 24.w,
              height: 24.w,
              child: Icon(
                JariBeanIconPack.gps,
                color: Colors.white,
                size: 24.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
