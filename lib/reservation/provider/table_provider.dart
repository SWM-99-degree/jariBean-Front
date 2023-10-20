import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/table_display_model.dart';
import 'package:jari_bean/cafe/model/table_model.dart';
import 'package:jari_bean/reservation/model/search_query_model.dart';
import 'package:jari_bean/reservation/model/table_query_model.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';
import 'package:jari_bean/reservation/repository/table_repository.dart';

final tableDisplayProvider = StateNotifierProvider.family
    .autoDispose<TableDisplayStateNotifier, List<TableDisplayModel>, String>(
  (ref, id) {
    final repository = ref.watch(tableRepositoryProvider);
    final searchQueryFilter = ref.watch(searchQueryProvider);
    return TableDisplayStateNotifier(
      cafeId: id,
      repository: repository,
      queryFilter: searchQueryFilter,
    );
  },
);

class TableDisplayStateNotifier extends StateNotifier<List<TableDisplayModel>> {
  final String cafeId;
  final TableRepository repository;
  final SearchQueryModel queryFilter;
  TableDisplayStateNotifier({
    required this.cafeId,
    required this.repository,
    required this.queryFilter,
  }) : super([]) {
    getTableDisplay();
  }

  Future<List<TableDetailModel>> getTables() async {
    return await repository.getTables(
      id: cafeId,
      query: TableQueryModel(
        startTime: queryFilter.startTime,
        endTime: queryFilter.endTime,
        headCount: queryFilter.headCount,
        tableOptionList: queryFilter.tableOptionList,
      ),
    );
  }

  void setToTableDisplay(List<TableDetailModel> tableModels) {
    state = tableModels.map((model) {
      return TableDisplayModel.calculateAvailablityFromTableModel(
        model: model,
        queryStartTime: queryFilter.startTime,
        queryEndTime: queryFilter.endTime,
      );
    }).toList();
  }

  Future<void> getTableDisplay() async {
    final tableModels = await getTables();
    setToTableDisplay(tableModels);
    applyFilter();
  }

  void applyFilter() {
    final filteredList = state.where((element) {
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
    state = filteredList;
  }
}
