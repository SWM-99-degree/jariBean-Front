import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/firebase/fcm.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/secure_storage/secure_storage.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/user/models/user_model.dart';
import 'package:jari_bean/user/provider/user_provider.dart';
import 'package:skeletons/skeletons.dart';

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
        onTap: () {
          context.push('/profile/alert');
        },
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
    //copy footerList contents into infoList
    final List<IconTitleFunctionModel> infoList = [
      IconTitleFunctionModel(
        iconData: Icons.receipt,
        title: '이용약관',
        onTap: () {},
      ),
      IconTitleFunctionModel(
        iconData: Icons.receipt,
        title: '개인정보 처리방침',
        onTap: () {},
      ),
      IconTitleFunctionModel(
        iconData: Icons.phone,
        title: '고객센터',
        onTap: () {},
      ),
      IconTitleFunctionModel(
        iconData: Icons.handshake,
        title: '제휴문의',
        onTap: () {},
      ),
      IconTitleFunctionModel(
        iconData: Icons.exit_to_app,
        title: '회원탈퇴',
        onTap: () {},
      ),
    ];

    return ListView(
      children: [
        Column(
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
                    child: Stack(
                      children: [
                        SkeletonAvatar(
                          style: SkeletonAvatarStyle(
                            width: 64.w,
                            height: 64.w,
                            borderRadius: BorderRadius.circular(32.w),
                          ),
                        ),
                        CircleAvatar(
                          radius: 32.w,
                          backgroundImage: NetworkImage(
                            user.imgUrl,
                          ),
                          backgroundColor: Colors.transparent,
                          onBackgroundImageError: (exception, stackTrace) {
                            print(exception);
                            print(stackTrace);
                          },
                        ),
                      ],
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
              child: CustomButton(
                text: '프로필 수정',
                onPressed: () {
                  context.push('/profile/edit');
                },
              ),
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
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => _settingItemBuilder(
                iconData: settingList[index].iconData,
                title: settingList[index].title,
                onTap: settingList[index].onTap,
              ),
              itemCount: settingList.length,
            ),
            SizedBox(
              height: 12.h,
            ),
            Container(
              height: 10.h,
              color: Color(0xFFF5F5F5),
            ),
            SizedBox(
              height: 12.h,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => _settingItemBuilder(
                iconData: infoList[index].iconData,
                title: infoList[index].title,
                onTap: infoList[index].onTap,
              ),
              itemCount: infoList.length,
            ),
          ],
        ),
      ],
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
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
            '소셜 로그인',
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
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16.w,
        ),
        onTap: () => onTap(),
      ),
    );
  }
}
