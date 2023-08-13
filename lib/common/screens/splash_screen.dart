import 'package:flutter/material.dart';
import 'package:jari_bean/common/const/color.dart';

class SplashScreen extends StatelessWidget {
  static String get routerName => '/splash';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.86, -0.52),
          end: Alignment(-0.86, 0.52),
          colors: [PRIMARY_YELLOW, PRIMARY_ORANGE],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '자리:Bean',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontFamily: 'Gmarket Sans TTF',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
