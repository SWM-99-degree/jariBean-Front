import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/cafe/model/cafe_detail_model.dart';
import 'package:jari_bean/cafe/model/table_model.dart';
import 'package:jari_bean/cafe/provider/cafe_provider.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/component/custom_dialog.dart';
import 'package:jari_bean/common/layout/default_card_layout.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/common/models/custom_button_model.dart';
import 'package:jari_bean/common/models/custom_dialog_model.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:jari_bean/reservation/model/table_reservation_model.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';
import 'package:jari_bean/reservation/provider/table_provider.dart';
import 'package:jari_bean/reservation/provider/table_reservation_provider.dart';

class TableReservationConfirmScreen extends ConsumerWidget {
  static String get routeName => '/reservation/confirm';
  const TableReservationConfirmScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableReservationInfo = ref.watch(tableReservationProvider);
    if (tableReservationInfo == null) {
      return DefaultLayout(
        title: '잘못된 요청',
        child: Center(
          child: Text(
            '잘못된 요청입니다.',
          ),
        ),
      );
    }
    final searchQuery = ref.watch(searchQueryProvider);
    final tableModel =
        ref.watch(tableProvider(tableReservationInfo.cafeId)).firstWhere(
              (element) =>
                  element.tableModel.id == tableReservationInfo.tableId,
            );
    final cafeModel =
        ref.watch(cafeInformationProvider(tableReservationInfo.cafeId));
    return DefaultLayout(
      title: '예약 확인',
      child: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '예약 정보',
                      style: defaultFontStyleBlack.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    _buildTimeInfo(tableReservationInfo),
                    SizedBox(
                      height: 10.h,
                    ),
                    _buildHeadcount(searchQuery.headCount),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(
                thickness: 10.h,
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '카페 정보',
                      style: defaultFontStyleBlack.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (cafeModel is! CafeDetailModel)
                      DefaultCardLayout.preloading(),
                    if (cafeModel is CafeDetailModel)
                      DefaultCardLayout.fromModel(model: cafeModel.cafeModel),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Divider(
                thickness: 10.h,
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '테이블 정보',
                      style: defaultFontStyleBlack.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          Icon(
                            Icons.table_chart,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            tableModel.tableModel.name,
                            style: defaultFontStyleBlack,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    _buildHeadcount(tableModel.tableModel.maxHeadcount),
                    _buildTableOptions(
                      tableModel.tableModel.tableOptionsList,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomButton(
                text: '예약하기',
                onPressed: () {
                  final state =
                      ref.read(tableReservationProvider.notifier).submit();
                  if (state) {
                    showCustomDialog(
                      context: context,
                      model: CustomDialogModel(
                        title: '예약 완료',
                        description: '예약이 완료되었습니다.',
                        customButtonModel: CustomButtonModel(
                          title: '확인',
                          onPressed: () {
                            while (context.canPop()) {
                              context.pop();
                            }
                            context.go('/');
                          },
                        ),
                      ),
                    )();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Row _buildHeadcount(int headCount) {
    return Row(
      children: [
        Icon(
          Icons.people,
          color: Colors.black,
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          '$headCount명',
          style: defaultFontStyleBlack,
        ),
      ],
    );
  }

  Row _buildTimeInfo(TableReservationModel tableReservationInfo) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          color: Colors.black,
        ),
        SizedBox(
          width: 10.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Utils.getYYYYMMDDHHMMfromDateTimeWithKorean(
                tableReservationInfo.startTime,
              ),
              style: defaultFontStyleBlack,
            ),
            Text(
              '${Utils.getHHMMfromDateTime(tableReservationInfo.startTime)} ~ ${Utils.getHHMMfromDateTime(tableReservationInfo.endTime)}',
              style: defaultFontStyleBlack.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildTableOptions(List<TableType> tableOptionsList) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.black,
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            '테이블 옵션',
            style: defaultFontStyleBlack,
          ),
        ],
      ),
      SizedBox(
        height: 10.h,
      ),
      Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: tableOptionsList
            .map(
              (e) => Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFEFEFEF),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  Utils.getButtonNameFromEnum(
                    enumValue: e,
                    map: tableTypeButtonName,
                  ),
                  style: defaultFontStyleBlack.copyWith(
                    fontSize: 12.sp,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ],
  );
}
