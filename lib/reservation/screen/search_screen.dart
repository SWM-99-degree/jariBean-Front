import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/component/custom_outlined_button.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:jari_bean/reservation/component/search_box.dart';
import 'package:jari_bean/reservation/model/search_query_model.dart';
import 'package:jari_bean/reservation/model/service_area_model.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';
import 'package:jari_bean/reservation/provider/service_area_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class SearchScreen extends ConsumerWidget {
  final String? serviceAreaId;
  static String get routerName => '/search';
  const SearchScreen({
    this.serviceAreaId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarTextStyle = defaultFontStyleBlack.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      height: 1.60,
      letterSpacing: -0.5,
    );
    final titleTextStyle = defaultFontStyleBlack.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      height: 1.5,
    );
    final ServiceAreaModel? serviceArea = ref
        .watch(serviceAreaProvider.notifier)
        .getServiceAreaById(serviceAreaId);
    final startTime = ref.watch(searchQueryProvider).startTime;
    final endTime = ref.watch(searchQueryProvider).endTime;
    final headCount = ref.watch(searchQueryProvider).headCount;
    final tableUsage = ref.watch(tableUsageProvider);
    final tableOptionsList = ref.watch(searchQueryProvider).tableOptionList;

    return DefaultLayout(
      titleWidget: Hero(
        tag: 'searchBox',
        child: SearchBox(
          searchArea: serviceArea?.name,
          hintText: '카페를 검색해주세요',
        ),
      ),
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 36.w,
              vertical: 16.h,
            ),
            child: _buildCalendar(startTime, ref, calendarTextStyle),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Divider(
              height: 10.h,
              thickness: 10.h,
              color: Color(0xFFE8E8E8),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('시간', style: titleTextStyle),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _timeButtonBuilder(
                        time: startTime,
                        onPressed: () {
                          _showIOSDatePicker(
                            context: context,
                            initialDateTime: startTime,
                            onDateTimeChanged: (value) {
                              ref
                                  .read(searchQueryProvider.notifier)
                                  .startTimeFromDateTime = value;
                            },
                          );
                        },
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text('~', style: titleTextStyle),
                      SizedBox(
                        width: 10.w,
                      ),
                      _timeButtonBuilder(
                        time: endTime,
                        onPressed: () {
                          _showIOSDatePicker(
                            context: context,
                            initialDateTime: endTime,
                            onDateTimeChanged: (value) {
                              ref
                                  .read(searchQueryProvider.notifier)
                                  .endTimeFromDateTime = value;
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text('인원', style: titleTextStyle),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  height: 50.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: _circledButton(
                          count: index + 1,
                          isSelected: headCount == index + 1,
                          onPressed: () {
                            ref.read(searchQueryProvider.notifier).headCount =
                                index + 1;
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text('목적', style: titleTextStyle),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  height: 37.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: TableUsage.values.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: CustomOutlinedButton(
                          onPressed: () {
                            ref.read(tableUsageProvider.notifier).tableUsage =
                                TableUsage.values[index];
                          },
                          text: Utils.getButtonNameFromEnum<TableUsage>(
                            enumValue: TableUsage.values[index],
                            map: tableUsageButtonName,
                          ),
                          isSelected: tableUsage == TableUsage.values[index],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text('옵션', style: titleTextStyle),
                SizedBox(
                  height: 8.h,
                ),
                SizedBox(
                  height: 37.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: TableType.values.length,
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
                          isSelected: tableOptionsList
                              .contains(TableType.values[index]),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 36.h,
                ),
                CustomButton(
                  text: '검색하기',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ConstrainedBox _circledButton({
    required int count,
    required bool isSelected,
    required Function() onPressed,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 50.w,
        maxHeight: 50.w,
      ),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(8.w),
          side: BorderSide(
            color: GRAY_2,
            width: 0.5.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          backgroundColor: isSelected ? PRIMARY_YELLOW : Colors.transparent,
        ),
        child: Text(
          '$count명',
          style: defaultFontStyleWhite.copyWith(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.64,
          ),
        ),
      ),
    );
  }

  TableCalendar<dynamic> _buildCalendar(
      DateTime startTime, WidgetRef ref, TextStyle calendarTextStyle) {
    return TableCalendar(
      focusedDay: startTime,
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(
        Duration(days: 365),
      ),
      locale: 'ko-KR',
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        headerPadding: EdgeInsets.only(bottom: 21.h),
        leftChevronMargin: EdgeInsets.only(
          left: 40.w,
        ),
        rightChevronMargin: EdgeInsets.only(
          right: 40.w,
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Colors.black,
          size: 24.w,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Colors.black,
          size: 24.w,
        ),
        titleTextStyle: defaultFontStyleBlack.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
      ),
      selectedDayPredicate: (day) => isSameDay(startTime, day),
      onDaySelected: (selectedDayLocal, focusedDayLocal) {
        if (!isSameDay(startTime, selectedDayLocal)) {
          ref.read(searchQueryProvider.notifier).dateFromDateTime =
              selectedDayLocal;
        }
      },
      weekendDays: const [DateTime.sunday],
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        defaultTextStyle: calendarTextStyle,
        disabledTextStyle: calendarTextStyle.copyWith(
          color: Color(0xFFE8E8E8),
        ),
        selectedDecoration: BoxDecoration(
          color: PRIMARY_YELLOW,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: GRAY_3,
          shape: BoxShape.circle,
        ),
        weekendTextStyle: calendarTextStyle.copyWith(
          color: Color(0xFFDF2D21),
        ),
        holidayTextStyle: calendarTextStyle.copyWith(
          color: Color(0xFFDF2D21),
        ),
      ),
    );
  }

  Widget _timeButtonBuilder({
    required DateTime time,
    required Function() onPressed,
  }) {
    final timeString = '${time.hour}:${time.minute == 0 ? '00' : time.minute}';
    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
          side: BorderSide(
            color: GRAY_2,
            width: 0.5.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              timeString,
              style: defaultFontStyleBlack.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.71,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 24.w,
              color: PRIMARY_YELLOW,
            ),
          ],
        ),
      ),
    );
  }

  void _showIOSDatePicker({
    required BuildContext context,
    required DateTime initialDateTime,
    required Function(DateTime) onDateTimeChanged,
  }) async {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Align(
        alignment: Alignment(0, 1),
        child: Container(
          height: 200.h,
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(
            children: [
              SizedBox(
                height: 200.h,
                child: CupertinoDatePicker(
                  minuteInterval: 15,
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialDateTime,
                  onDateTimeChanged: onDateTimeChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
