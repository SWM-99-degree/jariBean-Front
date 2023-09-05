import 'package:jari_bean/cafe/model/table_model.dart';
import 'package:jari_bean/common/const/data.dart';

enum TableDisplayStatus {
  available,
  unavailable,
  availableInScope,
  unavailableInScope,
}

class TableDisplayModel extends TableModel {
  final DateTime displayStartTime;
  final DateTime displayEndTime;
  final bool isAvaliable;
  final List<AvaliableTimeRange> alternativeAvaliableTimeRangeList;
  final List<TableDisplayStatus> displayUnitList;

  TableDisplayModel({
    required String id,
    required String name,
    required int maxHeadcount,
    required String imgUrl,
    required List<TableType> tableOptionsList,
    required List<AvaliableTimeRange> avaliableTimeRangeList,
    required this.displayStartTime,
    required this.displayEndTime,
    required this.isAvaliable,
    required this.alternativeAvaliableTimeRangeList,
    required this.displayUnitList,
  }) : super(
          id: id,
          name: name,
          maxHeadcount: maxHeadcount,
          imgUrl: imgUrl,
          tableOptionsList: tableOptionsList,
          avaliableTimeRangeList: avaliableTimeRangeList,
        );

  factory TableDisplayModel.calculateAvailablityFromTableModel({
    required TableModel model,
    required DateTime queryStartTime,
    required DateTime queryEndTime,
  }) {
    final displayTimeExpander = Duration(
      minutes: queryEndTime.difference(queryStartTime).inMinutes ~/ 2,
    );
    final displayStartTime = queryStartTime.subtract(displayTimeExpander);
    final displayEndTime = queryEndTime.add(displayTimeExpander);
    final isAvaliable = model.avaliableTimeRangeList.any((element) {
      return element.startTime.isBefore(queryStartTime) &&
          element.endTime.isAfter(queryEndTime);
    });
    final duration = Duration(minutes: 30);
    final List<AvaliableTimeRange> alternativeAvaliableTimeRangeListCandidates =
        [
      AvaliableTimeRange(
        startTime: queryStartTime.subtract(duration),
        endTime: queryEndTime.subtract(duration),
      ),
      AvaliableTimeRange(
        startTime: queryStartTime.add(duration),
        endTime: queryEndTime.add(duration),
      ),
      AvaliableTimeRange(
        startTime: queryStartTime,
        endTime: queryEndTime.subtract(duration),
      ),
      AvaliableTimeRange(
        startTime: queryStartTime.add(duration),
        endTime: queryEndTime,
      ),
    ];
    final List<AvaliableTimeRange> alternativeAvaliableTimeRangeList = [];
    for (var element in alternativeAvaliableTimeRangeListCandidates) {
      if (model.avaliableTimeRangeList.any((e) {
        return e.startTime.isBefore(element.startTime) &&
            e.endTime.isAfter(element.endTime);
      })) {
        alternativeAvaliableTimeRangeList.remove(element);
      }
    }
    final List<TableDisplayStatus> displayUnitList = [];

    List<TableDisplayStatus> getReplaceUnit(
      int cnt,
      TableDisplayStatus status,
    ) {
      final List<TableDisplayStatus> ret = [];
      for (int i = 0; i < cnt; ++i) {
        ret.add(status);
      }
      return ret;
    }

    int getIndexFromTime(DateTime s) {
      final diff = s.difference(displayStartTime).inMinutes;
      return diff ~/ TIME_UNIT;
    }

    void changeColorFromTime(
      DateTime s,
      DateTime e,
      TableDisplayStatus status,
    ) {
      final int start = getIndexFromTime(s);
      final int end = getIndexFromTime(e);
      displayUnitList.replaceRange(
        start,
        end,
        getReplaceUnit(
          end - start,
          status,
        ),
      );
    }

    final timeInterval = displayEndTime.difference(displayStartTime).inMinutes;
    final queryStartIndex = timeInterval / 4;
    final queryEndIndex = timeInterval * 3 / 4;

    for (int i = 0;
        i < displayEndTime.difference(displayStartTime).inMinutes;
        i += TIME_UNIT) {
      if (queryStartIndex <= i && i < queryEndIndex) {
        displayUnitList.add(TableDisplayStatus.unavailableInScope);
      } else {
        displayUnitList.add(TableDisplayStatus.unavailable);
      }
    }

    for (var element in model.avaliableTimeRangeList) {
      if (!element.endTime.isAfter(displayStartTime)) continue;
      if (!element.startTime.isBefore(displayEndTime)) continue;
      DateTime st = element.startTime;
      DateTime et = element.endTime;
      DateTime tempSt = element.startTime;
      DateTime tempEt = element.endTime;
      if (st.isBefore(displayStartTime)) {
        st = displayStartTime;
      }
      if (et.isAfter(displayEndTime)) {
        et = displayEndTime;
      }
      if (st.isBefore(queryStartTime)) {
        tempEt = tempEt.isAfter(queryStartTime) ? queryStartTime : et;
        changeColorFromTime(st, tempEt, TableDisplayStatus.available);
        st = tempEt;
      }
      if (et.isAfter(queryEndTime)) {
        tempSt = tempSt.isBefore(queryEndTime) ? queryEndTime : st;
        changeColorFromTime(tempSt, et, TableDisplayStatus.available);
        et = tempSt;
      }
      if (!st.isBefore(queryStartTime) && !et.isAfter(queryEndTime)) {
        changeColorFromTime(st, et, TableDisplayStatus.availableInScope);
      }
    }

    return TableDisplayModel(
      id: model.id,
      name: model.name,
      maxHeadcount: model.maxHeadcount,
      imgUrl: model.imgUrl,
      tableOptionsList: model.tableOptionsList,
      avaliableTimeRangeList: model.avaliableTimeRangeList,
      displayStartTime: displayStartTime,
      displayEndTime: displayEndTime,
      isAvaliable: isAvaliable,
      displayUnitList: displayUnitList,
      alternativeAvaliableTimeRangeList: alternativeAvaliableTimeRangeList,
    );
  }
}
