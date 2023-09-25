import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/reservation/screen/result_screen.dart';

class CafeDetailTableScreen extends ConsumerWidget {
  final String cafeId;
  const CafeDetailTableScreen({
    required this.cafeId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResultScreen(cafeId: cafeId);
  }
}
