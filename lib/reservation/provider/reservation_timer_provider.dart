import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final reservationTimerProvider = StateNotifierProvider<TimerStateNotifier, int>(
  (ref) {
    ref.onDispose(() {
      print('timer Disposed');
    });
    return TimerStateNotifier();
  },
);

class TimerStateNotifier extends StateNotifier<int> {
  bool flag = false;
  TimerStateNotifier() : super(0);

  Future<void> initTimer({
    required int initTimeLeft,
    Function? callback,
  }) async {
    if (flag) return;
    flag = true;
    state = initTimeLeft;
    Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        final currentTimeLeft = state;
        if (currentTimeLeft <= 0) {
          timer.cancel();
          state = 0;
          flag = false;
          if (callback != null) {
            callback();
          }
          return;
        }
        state = currentTimeLeft - 1;
      },
    );
  }

  get timeLeftInSeconds {
    return state;
  }

  void resetTimer() {
    state = 0;
  }
}
