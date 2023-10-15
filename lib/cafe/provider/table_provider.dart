import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/table_display_model.dart';
import 'package:jari_bean/cafe/model/table_model.dart';
import 'package:jari_bean/cafe/repository/table_repository.dart';
import 'package:jari_bean/reservation/model/search_query_model.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';

final tableProvider = StateNotifierProvider.family<TableStateNotifier,
    List<TableDetailModel>, String>((ref, id) {
  final tableRepository = ref.watch(tableRepositoryProvider);
  return TableStateNotifier(
    cafeId: id,
    repository: tableRepository,
  );
});

class TableStateNotifier extends StateNotifier<List<TableDetailModel>> {
  final String cafeId;
  final TableRepository repository;
  TableStateNotifier({
    required this.cafeId,
    required this.repository,
  }) : super([]) {
    getTables();
  }

  Future<void> getTables() async {
    final tables = await repository.getTables(cafeId);
    state = tables;
  }
}

final tableDisplayProvider = StateNotifierProvider.family<
    TableDisplayStateNotifier, List<TableDisplayModel>, String>(
  (ref, id) {
    final tableModels = ref.watch(tableProvider(id));
    final searchQueryFilter = ref.watch(searchQueryProvider);
    return TableDisplayStateNotifier(
      tableModels: tableModels,
      queryFilter: searchQueryFilter,
    );
  },
);

class TableDisplayStateNotifier extends StateNotifier<List<TableDisplayModel>> {
  final List<TableDetailModel> tableModels;
  final SearchQueryModel queryFilter;
  TableDisplayStateNotifier({
    required this.tableModels,
    required this.queryFilter,
  }) : super([]) {
    getTableDisplay();
  }

  Future<void> getTableDisplay() async {
    final tableDisplayList = tableModels.map((model) {
      return TableDisplayModel.calculateAvailablityFromTableModel(
        model: model,
        queryStartTime: queryFilter.startTime,
        queryEndTime: queryFilter.endTime,
      );
    }).toList();
    state = tableDisplayList;
    applyFilter();
  }

  void applyFilter() {
    final filteredList = state.where((element) {
      // if (!element.isAvaliable) return false;
      if (element.tableModel.maxHeadcount < queryFilter.headCount) return false;
      if (queryFilter.tableOptionList
          .every((e) => element.tableModel.tableOptionsList.contains(e))) {
        return true;
      }
      return false;
    }).toList();
    state = filteredList;
  }
}
