import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/firebase/fcm.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/secure_storage/secure_storage.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/user/models/user_model.dart';
import 'package:jari_bean/user/provider/user_provider.dart';

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

class ProfileScreen extends ConsumerWidget {
  static String get routerName => '/profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(userProvider);
    if (userModel == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    final user = userModel
        as UserModel; //must be UserModel since GoRouter redirect logic will kick if not logged in

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
      IconTitleFunctionModel(
        iconData: Icons.logout,
        title: 'Logout',
        onTap: () {
          ref.read(userProvider.notifier).logout();
        },
      ),
      IconTitleFunctionModel(
        iconData: Icons.token_outlined,
        title: 'Get Access Token',
        onTap: () async {
          print(
            await ref.read(secureStorageProvider).read(key: ACCESS_TOKEN_KEY),
          );
        },
      ),
      IconTitleFunctionModel(
        iconData: Icons.token_outlined,
        title: 'Get Fcm Token',
        onTap: () {
          Clipboard.setData(
            ClipboardData(text: ref.read(fcmTokenProvider)),
          );
        },
      ),
    ];
    final List<Map<String, Function>> footerList = [
      {'이용약관': () {}},
      {'개인정보 처리방침': () {}},
      {'고객센터': () {}},
      {'제휴문의': () {}},
      {'회원탈퇴': () {}},
    ];
    return SingleChildScrollView(
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: 20.h,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                SizedBox(
                  width: 64.w,
                  height: 64.w,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.imgUrl,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.nickname,
                      style: defaultFontStyleBlack.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 4.h,
                    ),
                    Text(
                      user.description ?? '상태 메시지를 입력해 주세요',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: CustomButton(text: '프로필 수정', onPressed: () {}),
          ),
          SizedBox(
            height: 16.h,
          ),
          Container(
            height: 10.h,
            color: Color(0xFFF5F5F5),
          ),
          SizedBox(
            height: 12.h,
          ),
          _buildSocialType(user.socialLoginType),
          SizedBox(
            height: 12.h,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => _settingItemBuilder(
              iconData: settingList[index].iconData,
              title: settingList[index].title,
              onTap: settingList[index].onTap,
            ),
            separatorBuilder: (context, index) => SizedBox(
              height: 12.h,
            ),
            itemCount: settingList.length,
          ),
          _buildFooter(footerList),
        ],
      ),
    );
  }

  Widget _buildSocialType(SocialLoginType? socialLoginType) {
    late final String socialLoginTypeText;
    switch (socialLoginType) {
      case SocialLoginType.google:
        socialLoginTypeText = 'Google';
        break;
      case SocialLoginType.kakao:
        socialLoginTypeText = 'Kakao';
        break;
      case SocialLoginType.apple:
        socialLoginTypeText = 'Apple';
        break;
      default:
        socialLoginTypeText = 'Unknown';
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(
            JariBeanIconPack.profile,
            size: 20.w,
          ),
          SizedBox(
            width: 12.w,
          ),
          Text(
            '설정',
            style: defaultFontStyleBlack.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          ),
          SizedBox(
            width: 12.w,
          ),
          Text(
            socialLoginTypeText,
            style: defaultFontStyleBlack.copyWith(
              color: PRIMARY_YELLOW,
              fontWeight: FontWeight.w500,
              height: 1,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFooter(List<Map<String, Function>> footerList) {
    return Container(
      width: 375.w,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '자리:Bean',
            style: defaultFontStyleBlack.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: GRAY_4,
              height: 1,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () => footerList[index].values.first,
                      child: Text(
                        footerList[index].keys.first,
                        style: defaultFontStyleBlack.copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: GRAY_3,
                          height: 0,
                        ),
                      ),
                    );
                  },
                  itemCount: footerList.length,
                  shrinkWrap: true,
                ),
              ),
              Text(
                'Copyright ⓒ 99℃ All rights Reserved',
                style: defaultFontStyleBlack.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: GRAY_3,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _settingItemBuilder({
    required IconData iconData,
    required String title,
    required Function onTap,
  }) {
    return Padding(
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
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.w,
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
