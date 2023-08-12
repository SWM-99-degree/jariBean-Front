import 'package:flutter/material.dart';
import 'package:jari_bean/common/const/color.dart';

class CustomButton extends StatelessWidget {
  final double? width;
  final String text;
  final bool isDisabled;
  final Function() onPressed;
  const CustomButton(
      {this.width,
      required this.text,
      required this.onPressed,
      this.isDisabled = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled == true ? GRAY_2 : PRIMARY_YELLOW,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        fixedSize: const Size(335, 52),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: TEXTFIELD_INNER,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
