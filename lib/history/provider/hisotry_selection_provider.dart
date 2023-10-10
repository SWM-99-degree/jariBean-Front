import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HistorySelection { reservation, matching }

final historySelectionProvider =
    StateNotifierProvider<HistorySelectionStateNotifier, HistorySelection>((ref) {
  return HistorySelectionStateNotifier();
});

class HistorySelectionStateNotifier extends StateNotifier<HistorySelection> {
  HistorySelectionStateNotifier() : super(HistorySelection.reservation);

  void toggle() {
    state = state == HistorySelection.reservation
        ? HistorySelection.matching
        : HistorySelection.reservation;
  }

  void update(HistorySelection selection) {
    state = selection;
  }
}
