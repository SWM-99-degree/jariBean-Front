import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/alert/model/alert_announcement_model.dart';
import 'package:jari_bean/alert/model/alert_model.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/models/fcm_message_model.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/common/utils/utils.dart';

class AlertCard extends StatelessWidget {
  final String id;
  final String title;
  final DateTime createdAt;
  final PushMessageType? type;
  final Function()? onTap;
  const AlertCard({
    required this.id,
    required this.title,
    required this.createdAt,
    this.type,
    this.onTap,
    super.key,
  });

  factory AlertCard.fromAnnouncementModel({
    required AlertAnnouncementModelBase model,
    Function()? onTap,
  }) {
    if (model is AlertAnnouncementModel) {
      return AlertCard(
        id: model.id,
        title: model.title,
        createdAt: model.createdAt,
        onTap: onTap,
      );
    }
    if (model is AlertAnnouncementLoadingModel) {
      return AlertCard(
        id: 'loading',
        title: 'loading',
        createdAt: DateTime.now(),
        onTap: onTap,
      );
    }
    return AlertCard(
      id: 'error',
      title: 'error',
      createdAt: DateTime.now(),
      onTap: onTap,
    );
  }

  factory AlertCard.fromAlertModel({
    required AlertModel model,
  }) {
    return AlertCard(
      id: model.id,
      title: model.title,
      createdAt: model.receivedAt,
      type: model.type,
    );
  }

  @override
  Widget build(BuildContext context) {
    late final Widget? leading;
    switch (type) {
      case PushMessageType.matchingSuccess:
        leading = Container(
          width: 32.w,
          height: 32.w,
          decoration: ShapeDecoration(
            color: Color(0xFF3CCA54),
            shape: CircleBorder(),
          ),
          child: Icon(
            Icons.check,
            size: 24.sp,
            color: Colors.white,
          ),
        );
        break;
      case PushMessageType.matchingFail:
        leading = Container(
          width: 32.w,
          height: 32.w,
          decoration: ShapeDecoration(
            color: Color(0xFFDF2C21),
            shape: CircleBorder(),
          ),
          child: Icon(
            Icons.error_outline_rounded,
            size: 24.sp,
            color: Colors.white,
          ),
        );
        break;
      case PushMessageType.matchingCancel:
        leading = Icon(
          Icons.notifications,
          size: 24.sp,
          color: PRIMARY_ORANGE,
        );
        break;
      case PushMessageType.matchingUrgent:
        leading = Icon(
          Icons.notifications,
          size: 24.sp,
          color: PRIMARY_ORANGE,
        );
        break;
      case PushMessageType.announcement:
        leading = Icon(
          Icons.notifications,
          size: 24.sp,
          color: PRIMARY_ORANGE,
        );
        break;
      case PushMessageType.ads:
        leading = Icon(
          Icons.notifications,
          size: 24.sp,
          color: PRIMARY_ORANGE,
        );
        break;
      case PushMessageType.reservationInfo:
        leading = Container(
          width: 32,
          height: 32,
          decoration: ShapeDecoration(
            color: Color(0xFF3CCA54),
            shape: OvalBorder(),
          ),
        );
        break;
      case PushMessageType.reservationComplete:
        leading = Container(
          width: 32.w,
          height: 32.w,
          decoration: ShapeDecoration(
            color: Color(0xFF3CCA54),
            shape: CircleBorder(),
          ),
          child: Icon(
            Icons.check,
            size: 24.sp,
            color: Colors.white,
          ),
        );
        break;
      case PushMessageType.reservationCanceled:
        leading = Icon(
          Icons.notifications,
          size: 24.sp,
          color: PRIMARY_ORANGE,
        );
        break;
      case PushMessageType.reservationUrgent:
        leading = Icon(
          Icons.notifications,
          size: 24.sp,
          color: PRIMARY_ORANGE,
        );
        break;
      default:
        leading = null;
    }
    return ListTile(
      leading: leading == null
          ? null
          : SizedBox(
              height: double.infinity,
              child: leading,
            ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      titleTextStyle: defaultFontStyleBlack.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        Utils.getYYYYMMDDHHMMfromDateTimeWithKorean(createdAt),
      ),
      subtitleTextStyle: defaultFontStyleBlack.copyWith(
        fontSize: 12.sp,
        color: GRAY_4,
        fontWeight: FontWeight.w400,
        height: 0.12,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.sp,
        color: GRAY_4,
      ),
      onTap: onTap,
    );
  }
}
