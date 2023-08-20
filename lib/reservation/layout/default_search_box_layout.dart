import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/const/color.dart';

class DefaultSearchBoxLayout extends StatelessWidget {
  final Function()? onPressed;
  final List<Widget> children;

  const DefaultSearchBoxLayout({
    required this.children,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      disabledColor: GRAY_1,
      elevation: 0.0,
      focusElevation: 0.0,
      color: GRAY_1,
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 10.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: GRAY_3,
            ),
            SizedBox(
              width: 8.w,
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}
