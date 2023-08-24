import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomSheet extends ConsumerWidget {
  final Widget? child;
  const CustomBottomSheet({
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.w),
      child: child,
    );
  }
}

showCustomBottomSheet({
  required BuildContext context,
  dynamic model,
}) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    backgroundColor: Colors.white,
    builder: (context) => CustomBottomSheet(),
  );
}

