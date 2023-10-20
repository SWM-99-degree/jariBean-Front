import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/table_display_model.dart';
import 'package:jari_bean/cafe/model/table_model.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:jari_bean/reservation/model/search_query_model.dart';
import 'package:jari_bean/reservation/model/table_query_model.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';
import 'package:jari_bean/reservation/repository/table_repository.dart';

final tableProvider = StateNotifierProvider.family
    .autoDispose<TableProvider, List<TableDetailModel>, String>(
  (ref, id) {
    final repository = ref.watch(tableRepositoryProvider);
    final query = ref.read(searchQueryProvider);
    return TableProvider(
      cafeId: id,
      repository: repository,
      query: query,
    );
  },
);

class TableProvider extends StateNotifier<List<TableDetailModel>> {
  final String cafeId;
  final TableRepository repository;
  final SearchQueryModel query;
  TableProvider({
    required this.cafeId,
    required this.repository,
    required this.query,
  }) : super([]) {
    getTables(queryFilter: query);
  }

  Future<void> getTables({
    required SearchQueryModel queryFilter,
  }) async {
    try {
      state = await repository.getTables(
        id: cafeId,
        query: TableQueryModel(
          startTime: queryFilter.startTime,
          endTime: queryFilter.endTime,
          headCount: queryFilter.headCount,
          tableOptionList: queryFilter.tableOptionList,
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}

final tableDisplayProvider = StateNotifierProvider.family
    .autoDispose<TableDisplayStateNotifier, List<TableDisplayModel>, String>(
  (ref, id) {
    final queryFilter = ref.watch(searchQueryProvider);
    final tables = ref.watch(tableProvider(id));
    ref.listen(searchQueryProvider, (previous, next) {
      if (previous == null) {
        ref.read(tableProvider(id).notifier).getTables(queryFilter: next);
        return;
      }
      if (Utils.isDifferentDay(previous.startTime, next.startTime)) {
        ref.read(tableProvider(id).notifier).getTables(queryFilter: next);
        return;
      }
    });
    return TableDisplayStateNotifier(
      cafeId: id,
      tables: tables,
      queryFilter: queryFilter,
    );
  },
);

class TableDisplayStateNotifier extends StateNotifier<List<TableDisplayModel>> {
  final String cafeId;
  final List<TableDetailModel> tables;
  final SearchQueryModel queryFilter;
  TableDisplayStateNotifier({
    required this.cafeId,
    required this.tables,
    required this.queryFilter,
  }) : super([]) {
    setToTableDisplay();
  }

  List<TableDetailModel> applyFilter() {
    final filteredList = tables.where((element) {
      // if (!element.isAvaliable) return false;
      if (element.tableModel.maxHeadcount < queryFilter.headCount) {
        return false;
      }
      if (queryFilter.tableOptionList
          .every((e) => element.tableModel.tableOptionsList.contains(e))) {
        return true;
      }
      return false;
    }).toList();
    return filteredList;
  }

  void setToTableDisplay() {
    final filteredTable = applyFilter();
    state = filteredTable.map((model) {
      return TableDisplayModel.calculateAvailablityFromTableModel(
        model: model,
        queryStartTime: queryFilter.startTime,
        queryEndTime: queryFilter.endTime,
      );
    }).toList();
  }
}
