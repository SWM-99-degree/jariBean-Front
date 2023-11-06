import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/cafe/model/table_model.dart';
import 'package:jari_bean/common/component/custom_button.dart';
import 'package:jari_bean/common/component/custom_outlined_button.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/const/data.dart';
import 'package:jari_bean/common/models/location_model.dart';
import 'package:jari_bean/common/provider/location_provider.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';
import 'package:table_calendar/table_calendar.dart';

enum FilterType {
  date,
  time,
  headCount,
  tableOption,
}

class QueryFilterScreen extends ConsumerWidget {
  final bool isFromServiceArea;
  const QueryFilterScreen({
    this.isFromServiceArea = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 36.w,
            vertical: 16.h,
          ),
          child: CalendarFilter(),
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
              if (!isFromServiceArea) LocationFilter(),
              SizedBox(
                height: 16.h,
              ),
              TimeFilter(),
              SizedBox(
                height: 16.h,
              ),
              HeadcountFilter(),
              SizedBox(
                height: 16.h,
              ),
              TableUsageFilter(),
              SizedBox(
                height: 16.h,
              ),
              TableOptionsFilter(),
              SizedBox(
                height: 36.h,
              ),
              CustomButton(
                text: '검색하기',
                onPressed: () {
                  context.push('/search/result');
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LocationFilter extends ConsumerWidget {
  const LocationFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleTextStyle = defaultFontStyleBlack.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      height: 1.5,
    );
    final geocode = ref.watch(geocodeProvider);
    final location = ref.watch(locationProvider);
    final bool isSet = location is LocationModel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('위치', style: titleTextStyle),
        SizedBox(
          height: 8.h,
        ),
        Padding(
          padding: EdgeInsets.only(right: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                geocode,
                style: defaultFontStyleBlack.copyWith(
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(
                width: 100.w,
                height: 40.h,
                child: CustomButton(
                  text: isSet ? '초기화' : '현재 위치',
                  onPressed: () async {
                    if (isSet) {
                      ref.read(searchQueryProvider.notifier).location = null;
                      ref.read(geocodeProvider.notifier).resetGeocode();
                    } else {
                      await ref.read(locationProvider.notifier).getLocation();
                      final location = ref.read(locationProvider);
                      if (location is LocationModel) {
                        ref.read(searchQueryProvider.notifier).location =
                            location;
                        final isSuccess = await ref
                            .read(geocodeProvider.notifier)
                            .getGeocode();
                        if (!isSuccess) {
                          ref.read(searchQueryProvider.notifier).location =
                              null;
                        }
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CalendarFilter extends ConsumerWidget {
  const CalendarFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarTextStyle = defaultFontStyleBlack.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      height: 1.60,
      letterSpacing: -0.5,
    );
    final startTime = ref.watch(searchQueryProvider).startTime;
    return TableCalendar(
      focusedDay: startTime,
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(
        Duration(days: 365),
      ),
      locale: 'ko-KR',
      availableGestures: AvailableGestures.none,
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
}

class TimeFilter extends ConsumerWidget {
  const TimeFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleTextStyle = defaultFontStyleBlack.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      height: 1.5,
    );
    final startTime = ref.watch(searchQueryProvider).startTime;
    final endTime = ref.watch(searchQueryProvider).endTime;
    final errorText = ref.watch(errorTextProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('시간', style: titleTextStyle),
        SizedBox(
          height: 16.h,
        ),
        Text(
          errorText,
          style: defaultFontStyleBlack.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: Color(0xFFDF2D21),
          ),
        ),
        SizedBox(
          height: 8.h,
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
                          .setStartTime(value);
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
                      ref.read(searchQueryProvider.notifier).setEndTime(value);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
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
    Timer? debounce;
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
                  minuteInterval: RESERVATION_TIME_UNIT,
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: initialDateTime,
                  onDateTimeChanged: (DateTime dateTime) {
                    if (debounce?.isActive ?? false) debounce?.cancel();
                    debounce = Timer(const Duration(milliseconds: 500), () {
                      onDateTimeChanged(dateTime);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeadcountFilter extends ConsumerWidget {
  const HeadcountFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleTextStyle = defaultFontStyleBlack.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      height: 1.5,
    );
    final headCount = ref.watch(searchQueryProvider).headCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
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
}

class TableUsageFilter extends ConsumerWidget {
  const TableUsageFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleTextStyle = defaultFontStyleBlack.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      height: 1.5,
    );
    final tableUsage = ref.watch(tableUsageProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}

class TableOptionsFilter extends ConsumerWidget {
  const TableOptionsFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleTextStyle = defaultFontStyleBlack.copyWith(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      height: 1.5,
    );
    final tableOptionsList = ref.watch(searchQueryProvider).tableOptionList;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  isSelected:
                      tableOptionsList.contains(TableType.values[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
