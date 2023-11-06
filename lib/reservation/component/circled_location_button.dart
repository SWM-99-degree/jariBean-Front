import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/models/location_model.dart';
import 'package:jari_bean/common/provider/location_provider.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/reservation/model/service_area_model.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';

class CircledLocationButton extends ConsumerWidget {
  final String serivceAreaId;
  final String serivceAreaName;
  final String imgUrl;
  final LocationModel location;
  const CircledLocationButton({
    required this.serivceAreaId,
    required this.serivceAreaName,
    required this.imgUrl,
    required this.location,
    super.key,
  });

  factory CircledLocationButton.fromModel({
    required ServiceAreaModel model,
  }) {
    return CircledLocationButton(
      serivceAreaId: model.id,
      serivceAreaName: model.name,
      imgUrl: model.imgUrl,
      location: model.location,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          context.go('/search?serviceAreaId=$serivceAreaId');
          ref.read(searchQueryProvider.notifier).location = location;
          ref
              .read(geocodeProvider.notifier)
              .setGeocodeFromServiceAreaName(serivceAreaName);
        },
        child: Ink(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(imgUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.3),
                BlendMode.srcATop,
              ),
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
    return GestureDetector(
      onTap: () => context.go('/search'),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(100),
              child: Ink(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF9D46),
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
      ),
    );
  }
}
