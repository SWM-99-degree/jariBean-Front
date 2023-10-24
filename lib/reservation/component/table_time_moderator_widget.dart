import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:jari_bean/reservation/model/table_reservation_model.dart';
import 'package:jari_bean/reservation/provider/table_reservation_provider.dart';

class TableTimeModeratorWidget extends ConsumerWidget {
  final TableReservationInfo tableReservationInfo;
  const TableTimeModeratorWidget({
    required this.tableReservationInfo,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: EdgeInsets.only(
        top: 10.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...tableReservationInfo.tableReservationList.map(
            (e) => GestureDetector(
              onTap: () {
                ref.read(tableReservationProvider.notifier).setOption(e);
              },
              child: Container(
                width: 335.w,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(
                  bottom: 10.w,
                ),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: ref.watch(tableReservationProvider) == e
                          ? PRIMARY_YELLOW
                          : GRAY_3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Utils.getHHMMAmountfromDuration(e.endTime.difference(e.startTime))}으로 예약할게요',
                      style: defaultFontStyleBlack.copyWith(
                        fontSize: 16.sp,
                      ),
                    ),
                    Text(
                      '${Utils.getHHMMfromDateTime(e.startTime)}~${Utils.getHHMMfromDateTime(e.endTime)}',
                      style: defaultFontStyleBlack.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          CustomButton(
            text: '예약하기',
            isDisabled: ref.watch(tableReservationProvider) == null,
            onPressed: () {
              context.push('/reservation/confirm');
            },
          ),
        ],
      ),
    );
  }
}

class TableReservationSetAndForwardButton extends ConsumerWidget {
  final TableReservationModel tableReservationModel;
  const TableReservationSetAndForwardButton({
    required this.tableReservationModel,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomButton(
      text: '예약하기',
      onPressed: () {
        ref
            .read(tableReservationProvider.notifier)
            .setOption(tableReservationModel);
        context.push('/reservation/confirm');
      },
    );
  }
}
