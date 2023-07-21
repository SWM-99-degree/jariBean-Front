import 'package:flutter/material.dart';
import 'package:jari_bean/common/const/color.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final String text;
  final bool isDisabled;
  final Function() onTap;
  const CustomButton(
      {this.width,
      required this.text,
      required this.onTap,
      this.isDisabled = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: width ?? double.infinity,
        height: 52,
        decoration: ShapeDecoration(
          color: isDisabled == true ? GRAY_2 : PRIMARY_YELLOW,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: TEXTFIELD_INNER,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
