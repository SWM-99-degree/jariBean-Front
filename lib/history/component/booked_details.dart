import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/component/custom_outlined_button_for_cafe_detail.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:jari_bean/history/model/booked_details_model.dart';

class BookedDetails extends StatelessWidget {
  final DateTime startTime;
  final DateTime? endTime;
  final int headCount;
  const BookedDetails({
    required this.startTime,
    this.endTime,
    required this.headCount,
    super.key,
  });

  factory BookedDetails.fromModel({
    required BookedDetailsModel model,
  }) {
    return BookedDetails(
      startTime: model.startTime,
      endTime: model.endTime,
      headCount: model.headCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    // temporary violation of MVVM pattern due to DTO structure
    bool isExpired = startTime.isBefore(DateTime.now());
    return Container(
      padding: EdgeInsets.only(
        top: 8,
      ),
      child: SizedBox(
        height: 30.h,
        width: 200.w,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            CustomOutlinedButtonForCafeDetail(
              text: _dateTimeToString(startTime),
              onPressed: null,
              isDisabled: isExpired,
            ),
            SizedBox(
              width: 4.w,
            ),
            if (endTime != null)
              CustomOutlinedButtonForCafeDetail(
                text: Utils.getHHMMAmountfromDuration(
                  endTime!.difference(startTime),
                ),
                onPressed: null,
                isDisabled: isExpired,
              ),
            if (endTime != null)
              SizedBox(
                width: 4.w,
              ),
            CustomOutlinedButtonForCafeDetail(
              text: '$headCount명',
              onPressed: null,
              isDisabled: isExpired,
            ),
          ],
        ),
      ),
    );
  }

  String _dateTimeToString(DateTime time) {
    final isBeforeNoon = time.hour < 12;
    return '${isBeforeNoon ? '오전' : '오후'} ${Utils.getHHMMfromDateTime(time)}';
  }
}
