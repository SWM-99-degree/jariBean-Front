import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/cafe/model/cafe_descripton_with_time_left_model.dart';
import 'package:jari_bean/history/model/history_model.dart';
import 'package:jari_bean/history/provider/history_provider.dart';
import 'package:jari_bean/reservation/provider/reservation_timer_provider.dart';

final urgentReservationProvider = StateNotifierProvider.autoDispose<
    UrgentReservationStateNotifier, CafeDescriptionModelBase?>(
  (ref) {
    return UrgentReservationStateNotifier(
      reservation: ref.watch(todayReservationProvider),
      initTimerFunction: ref.read(reservationTimerProvider.notifier).initTimer,
    );
  },
);

class UrgentReservationStateNotifier
    extends StateNotifier<CafeDescriptionModelBase?> {
  final ReservationModelBase? reservation;
  final Future<void> Function({required int initTimeLeft}) initTimerFunction;
  UrgentReservationStateNotifier({
    required this.reservation,
    required this.initTimerFunction,
  }) : super(CafeDescriptionModelLoading()) {
    initTimer();
  }

  initTimer() async {
    if (reservation == null || reservation is! ReservationModel) {
      state = null;
      return;
    }
    await Future(() {}); // fake future prevent error
    final pReservation = reservation as ReservationModel;
    int initTimeLeft =
        pReservation.startTime.difference(DateTime.now()).inSeconds;
    initTimeLeft = initTimeLeft < 0 ? 0 : initTimeLeft;
    initTimerFunction(
      initTimeLeft: initTimeLeft,
    );
    state = CafeDescriptionWithTimeLeftModel(
      id: pReservation.model.id,
      title: pReservation.model.title,
      imgUrl: pReservation.model.imgUrl,
      cafeAddress: pReservation.model.cafeAddress,
    );
  }
}
