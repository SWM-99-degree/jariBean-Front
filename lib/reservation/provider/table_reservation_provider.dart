import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/reservation/model/table_reservation_model.dart';
import 'package:jari_bean/reservation/repository/table_repository.dart';

final tableReservationProvider = StateNotifierProvider.autoDispose<
    TableReservationStateNotifier, TableReservationModel?>((ref) {
  final repository = ref.watch(tableReservationRepositoryProvider);
  return TableReservationStateNotifier(
    repository: repository,
  );
});

class TableReservationStateNotifier
    extends StateNotifier<TableReservationModel?> {
  final TableReservationRepository repository;
  TableReservationStateNotifier({
    required this.repository,
  }) : super(null);

  void setOption(TableReservationModel model) {
    state = model;
  }

  bool compareTableReservation(TableReservationModel model) {
    if (state == null) {
      return false;
    }
    return state!.tableId == model.tableId &&
        state!.startTime == model.startTime &&
        state!.endTime == model.endTime;
  }

  bool submit() {
    if (state == null) {
      return false;
    }
    try {
      repository.reserveTable(
        body: state!,
      );
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
}
