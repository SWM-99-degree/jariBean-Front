import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CafeDescription extends StatelessWidget {
  const CafeDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '스타벅스 고대점',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
        Text(
          '서울특별시 성북구 고려대로 24길 51',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
