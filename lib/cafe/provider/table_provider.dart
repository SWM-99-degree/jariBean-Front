import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/cafe_total_information_model.dart';
import 'package:jari_bean/cafe/model/table_display_model.dart';
import 'package:jari_bean/cafe/provider/cafe_provider.dart';
import 'package:jari_bean/reservation/model/search_query_model.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';

final tableDisplayProvider = StateNotifierProvider.family
    .autoDispose<TableDisplayStateNotifier, List<TableDisplayModel>, String>(
  (ref, id) {
    final cafeModel = ref.watch(cafeInformationProvider(id));
    final searchQueryFilter = ref.watch(searchQueryProvider);
    return TableDisplayStateNotifier(
      cafeModel: cafeModel,
      queryFilter: searchQueryFilter,
    );
  },
);

class TableDisplayStateNotifier extends StateNotifier<List<TableDisplayModel>> {
  final CafeTotalInformationBase cafeModel;
  final SearchQueryModel queryFilter;
  TableDisplayStateNotifier({
    required this.cafeModel,
    required this.queryFilter,
  }) : super([]) {
    getTableDisplay();
  }

  Future<void> getTableDisplay() async {
    if (cafeModel is! CafeTotalInformationModel) {
      return; // cafeModel must be loaded because this provider is called after cafe data and its screen rendering is done.
    }
    final tableModels =
        (cafeModel as CafeTotalInformationModel).tableDetailModelList;
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
