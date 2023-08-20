import 'package:flutter/material.dart';
import 'package:jari_bean/common/const/color.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool isPassword;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    this.autofocus = false,
    this.isPassword = false,
    this.hintText,
    this.errorText,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const baseBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: GRAY_3,
        width: 1.0,
      ),
    );

    return TextFormField(
      cursorColor: PRIMARY_YELLOW,
      obscureText: isPassword,
      autofocus: autofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: GRAY_3,
          fontSize: 14,
        ),
        fillColor: TEXTFIELD_INNER,
        filled: true,
        // 배경색을 넣으려면 filled: true를 넣어줘야함
        border: baseBorder,
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
          borderSide: baseBorder.borderSide.copyWith(
            color: PRIMARY_YELLOW,
          ),
        ),
      ),
    );
  }
}
