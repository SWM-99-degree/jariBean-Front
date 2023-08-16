import 'package:flutter_riverpod/flutter_riverpod.dart';

final matchingHeadcountProvider =
    StateNotifierProvider<MatchingStateNotifier, int>(
        (ref) => MatchingStateNotifier());

class MatchingStateNotifier extends StateNotifier<int> {
  static const maxHeadcount = 6;
  static const minHeadcount = 1;
  MatchingStateNotifier() : super(2);

  int increment() {
    if (state < maxHeadcount) {
      state++;
    }
    return state;
  }

  int decrement() {
    if (state > minHeadcount) {
      state--;
    }
    return state;
  }
}
