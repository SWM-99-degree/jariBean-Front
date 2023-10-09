import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/alert/model/alert_announcement_model.dart';
import 'package:jari_bean/alert/provider/alert_announcement_provider.dart';
import 'package:jari_bean/common/component/pagination_list_view.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/common/utils/utils.dart';

class AlertAnnouncementScreen extends ConsumerWidget {
  const AlertAnnouncementScreen({super.key});
  static String get routerName => '/alert/announcement';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView<AlertAnnouncementModel>(
      provider: alertAnnouncementProvider,
      itemBuilder: (context, ref, index, model) {
        return ListTile(
          title: Text(model.id),
          titleTextStyle: defaultFontStyleBlack.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 0.11,
          ),
          subtitle: Text(
            Utils.getYYYYMMDDHHMMfromDateTimeWithKorean(model.createdAt),
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
        );
      },
    );
  }
}
