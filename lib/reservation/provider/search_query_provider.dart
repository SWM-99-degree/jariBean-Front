import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/table_model.dart';
import 'package:jari_bean/common/models/location_model.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:jari_bean/reservation/model/search_query_model.dart';

final searchQueryProvider =
    StateNotifierProvider<SearchQueryStateNotifier, SearchQueryModel>(
  (ref) {
    final errorText = ref.watch(errorTextProvider.notifier);

    return SearchQueryStateNotifier(
      errorTextProvider: errorText,
    );
  },
);

class SearchQueryStateNotifier extends StateNotifier<SearchQueryModel> {
  final StateController<String> errorTextProvider;
  SearchQueryStateNotifier({
    required this.errorTextProvider,
  }) : super(
          SearchQueryModel(
            searchText: '',
            serviceAreaId: null,
            location: null,
            startTime: Utils.truncateToTimeUnit(
              DateTime.now(),
            ),
            endTime: Utils.truncateToTimeUnit(
              DateTime.now().add(
                Duration(hours: 1),
              ),
            ),
            headCount: 2,
            tableOptionList: [],
          ),
        );

  set serviceAreaId(String? serviceAreaId) {
    state = state.copyWithServiceAreaId(serviceAreaId);
  }

  set location(LocationModel? location) {
    state = state.copyWithLocation(location);
  }

  set startTime(DateTime startTime) {
    state = state.copyWith(startTime: startTime);
  }

  set endTime(DateTime endTime) {
    state = state.copyWith(endTime: endTime);
  }

  bool setStartTime(DateTime startTime) {
    if (!startTime.isBefore(state.endTime)) {
      errorTextProvider.state = '시작 시간은 종료 시간보다 빨라야 합니다.';
      return false;
    }
    if (startTime.isBefore(DateTime.now())) {
      errorTextProvider.state = '시작 시간은 현재 시간보다 빨라야 합니다.';
      return false;
    }
    errorTextProvider.state = '';
    state = state.copyWith(startTime: startTime);
    return true;
  }

  bool setEndTime(DateTime endTime) {
    if (!endTime.isAfter(state.startTime)) {
      errorTextProvider.state = '종료 시간은 시작 시간보다 늦어야 합니다.';
      return false;
    }
    errorTextProvider.state = '';
    state = state.copyWith(endTime: endTime);
    return true;
  }

  set headCount(int headCount) {
    state = state.copyWith(headCount: headCount);
  }

  set tableOptionList(List<TableType> tableOptionList) {
    state = state.copyWith(tableOptionList: tableOptionList);
  }

  set dateFromDateTime(DateTime date) {
    state = state.copyWith(
      startTime: Utils.truncateToTimeUnit(
        DateTime(
          date.year,
          date.month,
          date.day,
          state.startTime.hour,
          state.startTime.minute,
        ),
      ),
      endTime: Utils.truncateToTimeUnit(
        DateTime(
          date.year,
          date.month,
          date.day,
          state.endTime.hour,
          state.endTime.minute,
        ),
      ),
    );
  }

  set startTimeFromDateTime(DateTime time) {
    state = state.copyWith(
      startTime: time,
    );
  }

  set endTimeFromDateTime(DateTime time) {
    state = state.copyWith(
      endTime: time,
    );
  }

  void toggleTableOptions(TableType tableType) {
    final curtableOptionsList = state.tableOptionList;
    if (isTableOptionsSelected(tableType)) {
      state = state.copyWith(
        tableOptionList: curtableOptionsList
          ..removeWhere((element) => element == tableType),
      );
    } else {
      state = state.copyWith(
        tableOptionList: curtableOptionsList..add(tableType),
      );
    }
  }

  bool isTableOptionsSelected(TableType tableType) {
    return state.tableOptionList.contains(tableType);
  }
}

enum TableUsage {
  study,
  conference,
  chat,
  date,
}

final tableUsageButtonName = {
  TableUsage.study: '스터디',
  TableUsage.conference: '회의',
  TableUsage.chat: '수다',
  TableUsage.date: '데이트',
};

final tableUsageProvider =
    StateNotifierProvider.autoDispose<TableUsageStateNotifier, TableUsage?>(
  (ref) {
    final searchQuery = ref.watch(searchQueryProvider.notifier);
    return TableUsageStateNotifier(
      searchQueryModel: searchQuery,
    );
  },
);

class TableUsageStateNotifier extends StateNotifier<TableUsage?> {
  final SearchQueryStateNotifier searchQueryModel;
  TableUsageStateNotifier({
    required this.searchQueryModel,
  }) : super(null);

  set tableUsage(TableUsage usage) {
    updateQueryOptions(usage);
    state = usage;
  }

  void updateQueryOptions(TableUsage usage) {
    switch (usage) {
      case TableUsage.study:
        searchQueryModel.tableOptionList = [
          TableType.HIGH,
          TableType.BACKREST,
          TableType.PLUG,
          TableType.RECTANGLE,
        ];
        break;
      case TableUsage.conference:
        searchQueryModel.tableOptionList = [
          TableType.HIGH,
          TableType.BACKREST,
        ];
        break;
      case TableUsage.chat:
        searchQueryModel.tableOptionList = [];
        break;
      case TableUsage.date:
        searchQueryModel.tableOptionList = [];
        break;
      default:
        searchQueryModel.tableOptionList = [];
        break;
    }
  }
}

final errorTextProvider = StateProvider<String>((ref) {
  return '';
});
