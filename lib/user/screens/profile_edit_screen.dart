import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/component/custom_text_form_field.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/user/models/user_model.dart';
import 'package:jari_bean/user/provider/update_profile_provider.dart';
import 'package:jari_bean/user/provider/user_provider.dart';

class ProfileEditScreen extends ConsumerWidget {
  static String get routerName => '/profile/edit';
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userModel = ref.watch(userProvider);
    final updateProfile = ref.watch(updateProfileProvider);
    final bool isUpdated =
        ref.watch(updateProfileProvider.notifier).isUpdated();
    if (userModel == null) {
      return Center(
        child: Text('로그인이 필요합니다.'),
      );
    }
    final user = userModel as UserModel;
    return DefaultLayout(
      title: '프로필 수정',
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 16.h,
        ),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: () async {
                  ref.read(updateProfileProvider.notifier).updateImgFile();
                },
                child: _profileImageEditWidget(
                  image: updateProfile.imgFile == null
                      ? NetworkImage(user.imgUrl)
                      : Image.memory(updateProfile.imgFile!.files.first.bytes!)
                          .image,
                ),
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            Text(
              '닉네임',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            CustomTextFormField(
              onChanged: (text) {
                ref.read(updateProfileProvider.notifier).updateNickname(
                      nickname: text,
                    );
              },
              hintText: user.nickname,
            ),
            SizedBox(
              height: 16.h,
            ),
            Text(
              '자기소개',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            CustomTextFormField(
              maxLines: 4,
              onChanged: (text) {
                ref.read(updateProfileProvider.notifier).updateDescription(
                      description: text,
                    );
              },
              hintText: user.description ?? '상태 메시지를 입력해 주세요',
            ),
            SizedBox(
              height: 32.h,
            ),
            CustomButton(
              text: '프로필 적용',
              isDisabled: !isUpdated,
              onPressed: () {
                ref.read(userProvider.notifier).updateProfile(
                      body: updateProfile.toFormData(),
                    );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Stack _profileImageEditWidget({
    required ImageProvider image,
  }) {
    return Stack(
      children: [
        SizedBox(
          width: 80.w,
          height: 80.w,
          child: CircleAvatar(backgroundImage: image),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 25.w,
            height: 25.w,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: OvalBorder(),
              shadows: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 2,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Icon(
              Icons.edit,
              size: 16.sp,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
