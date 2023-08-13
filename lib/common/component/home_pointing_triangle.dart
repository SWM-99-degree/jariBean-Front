import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePointingTriangle extends ConsumerStatefulWidget {
  final bool isActive;
  const HomePointingTriangle({required this.isActive, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomePointingTriangleState();
}

class _HomePointingTriangleState extends ConsumerState<HomePointingTriangle> {

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastEaseInToSlowEaseOut,
      bottom: widget.isActive ? -16 * 1.2 / 2 : -30,
      child: Transform.rotate(
        angle: 3.14 / 4,
        child: Container(
          width: 16 * 1.2,
          height: 16 * 1.2,
          decoration: BoxDecoration(color: Colors.white),
        ),
      ),
    );
  }
}
