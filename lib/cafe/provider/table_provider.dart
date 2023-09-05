import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/table_display_model.dart';
import 'package:jari_bean/cafe/model/table_model.dart';
import 'package:jari_bean/cafe/repository/table_repository.dart';

final tableProvider =
    StateNotifierProvider.family<TableStateNotifier, List<TableModel>, String>(
        (ref, id) {
  final tableRepository = ref.watch(tableRepositoryProvider);
  return TableStateNotifier(
    cafeId: id,
    repository: tableRepository,
  );
});

class TableStateNotifier extends StateNotifier<List<TableModel>> {
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
