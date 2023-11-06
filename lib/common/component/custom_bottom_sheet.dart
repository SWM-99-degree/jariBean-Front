import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/reservation/component/table_time_moderator_widget.dart';
import 'package:jari_bean/reservation/model/table_reservation_model.dart';
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
  required Widget child,
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
      child: child,
    ),
  );
}

showCustomBottomSheetTableTimeReservationConfirmer({
  required BuildContext context,
  required Widget tableWidget,
  required TableReservationInfo tableReservationInfo,
}) {
  late final List<Widget> topper;
  late final Widget button;
  late final Function() onTap;
  if (tableReservationInfo.isAvailable) {
    topper = [
      Text(
        '예약 확인',
        style: defaultFontStyleBlack.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      Text(
        tableReservationInfo.tableReservationList.first.toConfirmString(),
        style: defaultFontStyleBlack.copyWith(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    ];
    button = TableReservationSetAndForwardButton(
      tableReservationModel: tableReservationInfo.tableReservationList.first,
    );
  } else {
    topper = [
      Text(
        '예약 시간 조정하기',
        style: defaultFontStyleBlack.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Color(0xFFFA4C40),
            size: 14.sp,
          ),
          Text(
            '30분만 조정하면 예약할 수 있어요!',
            style: defaultFontStyleBlack.copyWith(
              fontSize: 14.sp,
              color: Color(0xFFFA4C40),
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
          ),
        ],
      ),
    ];
    onTap = () => {
          showCustomBottomSheetTableTimeReservationModerator(
            context: context,
            tableReservationInfo: tableReservationInfo,
          ),
        };
    button = CustomButton(
      text: '예약 시간 조정하기',
      onPressed: onTap,
    );
  }
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
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...topper,
            SizedBox(
              height: 10.h,
            ),
            tableWidget,
            SizedBox(
              height: 20.h,
            ),
            button,
          ],
        ),
      ),
    ),
  );
}

showCustomBottomSheetTableTimeReservationModerator({
  required BuildContext context,
  required TableReservationInfo tableReservationInfo,
}) {
  final List<Widget> topper = [
    Text(
      '예약 시간 조정하기',
      style: defaultFontStyleBlack.copyWith(
        fontWeight: FontWeight.w700,
      ),
    ),
    Row(
      children: [
        Icon(
          Icons.info_outline,
          color: Color(0xFFFA4C40),
          size: 14.sp,
        ),
        Text(
          '30분만 조정하면 예약할 수 있어요!',
          style: defaultFontStyleBlack.copyWith(
            fontSize: 14.sp,
            color: Color(0xFFFA4C40),
            fontWeight: FontWeight.w600,
            height: 1.0,
          ),
        ),
      ],
    ),
  ];
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
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...topper,
            SizedBox(
              height: 10.h,
            ),
            TableTimeModeratorWidget(
              tableReservationInfo: tableReservationInfo,
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    ),
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

showDraggableModalSheet({
  required BuildContext context,
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
    builder: (context) => DraggableScrollableSheet(
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: CustomBottomSheet(
            child: Text('123'),
          ),
        );
      },
    ),
  );
}
