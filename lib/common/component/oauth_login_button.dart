import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OauthLoginButton extends StatelessWidget {
  final String imagePath;
  final bool? isLocal;
  final Function() onPressed;
  const OauthLoginButton(
      {required this.imagePath,
      required this.onPressed,
      this.isLocal = true,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: onPressed,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: isLocal!
                ? AssetImage(imagePath)
                : NetworkImage(imagePath) as ImageProvider,
          ),
        ),
      ),
    );
  }
}
