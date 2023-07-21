import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class OauthLoginButton extends StatelessWidget {
  final String imagePath;
  final bool? isLocal;
  final Function() onTap;
  const OauthLoginButton(
      {required this.imagePath,
      required this.onTap,
      this.isLocal = true,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
