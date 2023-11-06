import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/cafe/model/table_model.dart';
import 'package:jari_bean/common/component/custom_bottom_sheet.dart';
import 'package:jari_bean/common/component/custom_outlined_button.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';
import 'package:jari_bean/reservation/screen/query_filter_screen.dart';

class SimplifiedFilterScreen extends ConsumerWidget {
  const SimplifiedFilterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startTime = ref.watch(searchQueryProvider).startTime;
    final endTime = ref.watch(searchQueryProvider).endTime;
    final headCount = ref.watch(searchQueryProvider).headCount;
    final tableOptionsList = ref.watch(searchQueryProvider).tableOptionList;
    return Column(
      children: [
        Container(
          height: 44.h,
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 10.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                onPressed: () {
                  showCustomBottomSheetQueryFilter(
                    context: context,
                    filterType: FilterType.date,
                  );
                },
                child: buildDateDisplay(startTime),
              ),
              ...buildContour(),
              TextButton(
                onPressed: () {
                  showCustomBottomSheetQueryFilter(
                    context: context,
                    filterType: FilterType.time,
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: buildResevationTimeDisplay(startTime, endTime),
              ),
            ],
          ),
        ),
        Divider(
          height: 1.h,
          thickness: 1.h,
          color: GRAY_2,
        ),
        Container(
          height: 44.h,
          width: 385.w,
          padding: EdgeInsets.only(
            top: 6.h,
            bottom: 6.h,
          ),
          margin: EdgeInsets.only(
            left: 20.w,
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              IconButton(
                onPressed: () {
                  showCustomBottomSheetQueryFilter(
                    context: context,
                  );
                },
                constraints: BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: Icon(
                  JariBeanIconPack.filter,
                  size: 24.w,
                  color: Colors.black,
                ),
              ),
              ...buildContour(),
              CustomOutlinedButton(
                onPressed: () {
                  showCustomBottomSheetQueryFilter(
                    context: context,
                    filterType: FilterType.headCount,
                  );
                },
                text: '$headCount명',
                isSelected: true,
              ),
              SizedBox(
                width: 12.w,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: TableType.values.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(right: 12.w),
                      child: CustomOutlinedButton(
                        onPressed: () {
                          ref
                              .read(searchQueryProvider.notifier)
                              .toggleTableOptions(TableType.values[index]);
                          print(TableType.values[index]);
                        },
                        text: Utils.getButtonNameFromEnum<TableType>(
                          enumValue: TableType.values[index],
                          map: tableTypeButtonName,
                        ),
                        isSelected:
                            tableOptionsList.contains(TableType.values[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1.h,
          thickness: 1.h,
          color: GRAY_2,
        ),
      ],
    );
  }

  Row buildDateDisplay(DateTime startTime) {
    return Row(
      children: [
        Icon(
          JariBeanIconPack.calendar,
          size: 24.w,
          color: Colors.black,
        ),
        SizedBox(
          width: 8.w,
        ),
        Text(
          getMMDDfromDateTime(startTime),
          style: defaultFontStyleBlack.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: TEXT_SUBTITLE_COLOR,
          ),
        ),
      ],
    );
  }

  String getMMDDfromDateTime(DateTime dateTime) {
    return "${dateTime.month}월 ${dateTime.day}일";
  }

  Widget buildResevationTimeDisplay(DateTime startTime, DateTime endTime) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 24.w,
          color: Colors.black,
        ),
        SizedBox(
          width: 8.w,
        ),
        Text(
          "${Utils.getHHMMfromDateTime(startTime)} ~ ${startTime.day < endTime.day ? '다음날' : ''}${Utils.getHHMMfromDateTime(endTime)}",
          style: defaultFontStyleBlack.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: TEXT_SUBTITLE_COLOR,
          ),
        ),
      ],
    );
  }

  List<Widget> buildContour() {
    return [
      SizedBox(
        width: 16.w,
      ),
      Container(
        width: 1.w,
        height: 24.h,
        color: GRAY_2,
      ),
      SizedBox(
        width: 16.w,
      ),
    ];
  }
}
