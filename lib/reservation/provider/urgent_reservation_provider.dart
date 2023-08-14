import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/cafe/model/cafe_descripton_with_time_left_model.dart';
import 'package:jari_bean/reservation/provider/reservation_timer_provider.dart';
import 'package:jari_bean/reservation/repository/reservation_repository.dart';

final urgentReservationProvider = StateNotifierProvider<
    UrgentReservationStateNotifier, CafeDescriptionModelBase>(
  (ref) {
    return UrgentReservationStateNotifier(
      repository: ref.watch(reservationRepositoryProvider),
      initTimerFunction: ref.watch(reservationTimerProvider.notifier).initTimer,
    );
  },
);

class UrgentReservationStateNotifier
    extends StateNotifier<CafeDescriptionModelBase> {
  final ReservationRepository repository;
  final Future<void> Function({required int initTimeLeft}) initTimerFunction;
  UrgentReservationStateNotifier({
    required this.repository,
    required this.initTimerFunction,
  }) : super(CafeDescriptionModelLoading()) {
    fetch();
  }

  fetch() async {
    final resp = await repository.getUrgentReservation();
    int initTimeLeft = resp.reservedTime.difference(DateTime.now()).inSeconds;
    initTimeLeft = initTimeLeft < 0 ? 0 : initTimeLeft;
    initTimerFunction(
      initTimeLeft: initTimeLeft,
    );
    state = CafeDescriptionWithTimeLeftModel(
      id: resp.cafeDescriptionModel.id,
      title: resp.cafeDescriptionModel.title,
      imgUrl: resp.cafeDescriptionModel.imgUrl,
      cafeAddress: resp.cafeDescriptionModel.cafeAddress,
    );
  }
}
