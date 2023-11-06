import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/reservation/provider/reservation_timer_provider.dart';

final matchingTimerProvider = StateNotifierProvider<TimerStateNotifier, int>(
  (ref) {
    return TimerStateNotifier();
  },
);

final matchingInfoProvider = Provider((ref) {
  if (ref.watch(matchingTimerProvider) == 0) {
    return false;
  } else {
    return true;
  }
});
