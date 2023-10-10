import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/cafe/model/cafe_descripton_with_time_left_model.dart';
import 'package:jari_bean/history/repository/history_repository.dart';
import 'package:jari_bean/reservation/provider/reservation_timer_provider.dart';

final urgentReservationProvider = StateNotifierProvider<
    UrgentReservationStateNotifier, CafeDescriptionModelBase>(
  (ref) {
    return UrgentReservationStateNotifier(
      repository: ref.watch(todayReservationRepositoryProvider),
      initTimerFunction: ref.watch(reservationTimerProvider.notifier).initTimer,
    );
  },
);

class UrgentReservationStateNotifier
    extends StateNotifier<CafeDescriptionModelBase> {
  final TodayReservationRespository repository;
  final Future<void> Function({required int initTimeLeft}) initTimerFunction;
  UrgentReservationStateNotifier({
    required this.repository,
    required this.initTimerFunction,
  }) : super(CafeDescriptionModelLoading()) {
    fetch();
  }

  fetch() async {
    final resp = await repository.getTodayReservation();
    int initTimeLeft = resp.startTime.difference(DateTime.now()).inSeconds;
    initTimeLeft = initTimeLeft < 0 ? 0 : initTimeLeft;
    initTimerFunction(
      initTimeLeft: initTimeLeft,
    );
    state = CafeDescriptionWithTimeLeftModel(
      id: resp.model.id,
      title: resp.model.title,
      imgUrl: resp.model.imgUrl,
      cafeAddress: resp.model.cafeAddress,
    );
  }
}
