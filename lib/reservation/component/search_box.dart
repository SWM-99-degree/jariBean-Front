import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/const/color.dart';

class SearchBox extends ConsumerStatefulWidget {
  final String hintText;
  final Function(String)? onChanged;
  final bool readOnly;

  const SearchBox(
      {required this.hintText,
      this.onChanged,
      this.readOnly = false,
      super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchBoxState();
}

class _SearchBoxState extends ConsumerState<SearchBox> {
  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    );

    return Center(
      child: SizedBox(
        width: 335.w,
        child: TextFormField(
          cursorColor: GRAY_3,
          onChanged: widget.onChanged,
          readOnly: widget.readOnly,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(20),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: GRAY_3, fontSize: 14.sp),
            fillColor: GRAY_1,
            filled: true,
            // 배경색을 넣으려면 filled: true를 넣어줘야함
            border: baseBorder,
            enabledBorder: baseBorder,
            focusedBorder: baseBorder.copyWith(
              borderSide: baseBorder.borderSide.copyWith(
                color: GRAY_3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
