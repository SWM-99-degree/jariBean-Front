import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/style/default_font_style.dart';

class IconTitleFunctionModel {
  final IconData iconData;
  final String title;
  final Function onTap;

  IconTitleFunctionModel({
    required this.iconData,
    required this.title,
    required this.onTap,
  });
}

class ProfileAlertScreen extends ConsumerWidget {
  static String get routerName => '/profile/alert';
  const ProfileAlertScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<IconTitleFunctionModel> settingList = [
      IconTitleFunctionModel(
        iconData: JariBeanIconPack.notice,
        title: '알림',
        onTap: () {},
      ),
      IconTitleFunctionModel(
        iconData: JariBeanIconPack.information,
        title: '정보',
        onTap: () {},
      ),
    ];
    //copy footerList contents into infoList
    return ListView.builder(
      itemBuilder: (context, index) {
        return _settingItemBuilder(
          iconData: settingList[index].iconData,
          title: settingList[index].title,
          onTap: settingList[index].onTap,
        );
      },
      itemCount: settingList.length,
    );
  }

  Widget _settingItemBuilder({
    required IconData iconData,
    required String title,
    required Function onTap,
  }) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListTile(
        horizontalTitleGap: 12.w,
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        leading: SizedBox(
          height: double.infinity,
          child: Icon(
            color: Colors.black,
            iconData,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            title,
            style: defaultFontStyleBlack.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
        ),
        trailing: Switch(
          value: true,
          onChanged: (value) {},
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
