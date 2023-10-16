import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/cafe/model/table_display_model.dart';
import 'package:jari_bean/cafe/model/table_model.dart';
import 'package:jari_bean/common/const/color.dart';
import 'package:jari_bean/common/icons/jari_bean_icon_pack_icons.dart';
import 'package:jari_bean/common/layout/default_card_layout.dart';
import 'package:jari_bean/common/style/default_font_style.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';

class TableDescriptionCard extends ConsumerWidget {
  final String tableId;
  final String tableName;
  final int maxHeadcount;
  final String imgUrl;
  final List<TableType> tableOptionsList;
  final List<AvaliableTimeRange> avaliableTimeRangeList;
  final DateTime displayStartTime;
  final DateTime displayEndTime;
  final bool isAvaliable;
  final List<AvaliableTimeRange> alternativeAvaliableTimeRangeList;
  final List<TableDisplayStatus> displayUnitList;

  factory TableDescriptionCard.fromModel({
    required TableDetailModel model,
    required DateTime startTime,
    required DateTime endTime,
  }) {
    final tableDisplay = TableDisplayModel.calculateAvailablityFromTableModel(
      model: model,
      queryStartTime: startTime,
      queryEndTime: endTime,
    );
    return TableDescriptionCard(
      tableId: model.tableModel.id,
      tableName: model.tableModel.name,
      maxHeadcount: model.tableModel.maxHeadcount,
      imgUrl: model.tableModel.imgUrl,
      tableOptionsList: model.tableModel.tableOptionsList,
      avaliableTimeRangeList: model.avaliableTimeRangeList,
      displayStartTime: tableDisplay.displayStartTime,
      displayEndTime: tableDisplay.displayEndTime,
      isAvaliable: tableDisplay.isAvaliable,
      alternativeAvaliableTimeRangeList:
          tableDisplay.alternativeAvaliableTimeRangeList,
      displayUnitList: tableDisplay.displayUnitList,
    );
  }

  const TableDescriptionCard({
    super.key,
    required this.tableId,
    required this.tableName,
    required this.maxHeadcount,
    required this.imgUrl,
    required this.tableOptionsList,
    required this.avaliableTimeRangeList,
    required this.displayStartTime,
    required this.displayEndTime,
    required this.isAvaliable,
    required this.alternativeAvaliableTimeRangeList,
    required this.displayUnitList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultCardLayout(
      id: tableId,
      imgUrl: imgUrl,
      name: tableName,
      child: Expanded(
        child: Column(
          children: [
            _buildTableTitle(),
            SizedBox(
              height: 4.h,
            ),
            _buildTableOptions(),
            SizedBox(
              height: 8.h,
            ),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: GRAY_1,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  height: 16.h,
                ),
                _buildTimeDisplay(),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      Utils.getHHMMfromDateTime(
                        ref.watch(searchQueryProvider).startTime,
                      ),
                      style: defaultFontStyleBlack.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                        color: TEXT_SUBTITLE_COLOR,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      Utils.getHHMMfromDateTime(
                        ref.watch(searchQueryProvider).endTime,
                      ),
                      style: defaultFontStyleBlack.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                        color: TEXT_SUBTITLE_COLOR,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _buildTableTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            tableName,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left,
            style: defaultFontStyleBlack.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              JariBeanIconPack.person,
              size: 14.w,
            ),
            SizedBox(
              width: 2.w,
            ),
            Text(
              '$maxHeadcount명',
              style: defaultFontStyleBlack.copyWith(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: TEXT_SUBTITLE_COLOR,
              ),
            ),
          ],
        ),
      ],
    );
  }

  SizedBox _buildTableOptions() {
    return SizedBox(
      height: 18.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tableOptionsList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: 6.w),
              child: Text(
                '· ${Utils.getButtonNameFromEnum<TableType>(
                  enumValue: tableOptionsList[index],
                  map: tableTypeButtonName,
                )}',
                style: defaultFontStyleBlack.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: TEXT_SUBTITLE_COLOR,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Row _buildTimeDisplay() {
    TableDisplayStatus formerType = displayUnitList.first;
    int formerTypeLength = 1;
    final List<Widget> displayList = [];
    for (int i = 1; i < displayUnitList.length; ++i) {
      if (formerType != displayUnitList[i]) {
        displayList.add(
          Flexible(
            flex: formerTypeLength,
            child: Container(
              height: 16.h,
              decoration: BoxDecoration(
                color: switch (formerType) {
                  TableDisplayStatus.available => Colors.transparent,
                  TableDisplayStatus.unavailable => GRAY_3,
                  TableDisplayStatus.availableInScope => TIME_DISPLAY_GREEN,
                  TableDisplayStatus.unavailableInScope => TIME_DISPLAY_RED
                },
                borderRadius: BorderRadius.circular(
                  formerType == TableDisplayStatus.availableInScope ||
                          formerType == TableDisplayStatus.unavailableInScope
                      ? 2
                      : 0,
                ),
              ),
            ),
          ),
        );
        formerType = displayUnitList[i];
        formerTypeLength = 1;
      } else {
        formerTypeLength += 1;
      }
    }
    displayList.add(
      Flexible(
        flex: formerTypeLength,
        child: Container(
          height: 16.h,
          decoration: BoxDecoration(
            color: switch (formerType) {
              TableDisplayStatus.available => Colors.transparent,
              TableDisplayStatus.unavailable => GRAY_3,
              TableDisplayStatus.availableInScope => TIME_DISPLAY_GREEN,
              TableDisplayStatus.unavailableInScope => TIME_DISPLAY_RED
            },
            borderRadius: BorderRadius.circular(
              formerType == TableDisplayStatus.availableInScope ||
                      formerType == TableDisplayStatus.available
                  ? 2
                  : 0,
            ),
          ),
        ),
      ),
    );
    return Row(
      children: displayList,
    );
  }
}
