import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final reservationTimerProvider =
    StateNotifierProvider<ReservationTimerStateNotifier, int>(
  (ref) {
    return ReservationTimerStateNotifier();
  },
);

class ReservationTimerStateNotifier extends StateNotifier<int> {
  ReservationTimerStateNotifier() : super(0);

  Future<void> initTimer({
    required int initTimeLeft,
  }) async {
    state = initTimeLeft;
    Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        final currentTimeLeft = state;
        if (currentTimeLeft <= 0) {
          timer.cancel();
          state = 0;
          return;
        }
        state = currentTimeLeft - 1;
      },
    );
  }

  get timeLeftInSeconds {
    return state;
  }
}
