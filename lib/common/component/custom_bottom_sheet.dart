import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/reservation/screen/query_filter_screen.dart';

class CustomBottomSheet extends ConsumerWidget {
  final Widget? child;
  const CustomBottomSheet({
    this.child,
    super.key,
  });

  factory CustomBottomSheet.fromFilterType(FilterType? filterType) {
    final Widget? child;
    switch (filterType) {
      case FilterType.date:
        child = CalendarFilter();
      case FilterType.time:
        child = Container(
          padding: EdgeInsets.only(
            left: 20.w,
          ),
          height: 120.h,
          child: TimeFilter(),
        );
      case FilterType.headCount:
        child = Container(
          padding: EdgeInsets.only(
            left: 20.w,
          ),
          height: 120.h,
          child: HeadcountFilter(),
        );
      case FilterType.tableOption:
        child = SizedBox(
          height: 120.h,
          child: TableOptionsFilter(),
        );
      default:
        return CustomBottomSheet(
          child: QueryFilterScreen(),
        );
    }
    return CustomBottomSheet(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
        ),
        child: child,
      ),
    );
  }

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

showCustomBottomSheetQueryFilter({
  required BuildContext context,
  FilterType? filterType,
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
    builder: (context) => CustomBottomSheet(
      child: CustomBottomSheet.fromFilterType(filterType),
    ),
  );
}
