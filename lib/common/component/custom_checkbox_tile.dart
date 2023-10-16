import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/style/default_font_style.dart';

class CustomCheckboxTile extends StatelessWidget {
  final bool isChecked;
  final String title;
  final String description;
  final Function(bool?) onChanged;
  const CustomCheckboxTile({
    super.key,
    required this.isChecked,
    required this.title,
    required this.description,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 18.w,
          height: 18.w,
          child: Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: PRIMARY_ORANGE,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Text.rich(
          TextSpan(
            style: defaultFontStyleBlack.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: title,
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Center(
                  child: Icon(
                    JariBeanIconPack.arrow_right,
                    size: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
