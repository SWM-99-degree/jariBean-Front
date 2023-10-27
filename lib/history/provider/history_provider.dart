import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/provider/pagination_base_provider.dart';
import 'package:jari_bean/history/model/history_model.dart';
import 'package:jari_bean/history/repository/history_repository.dart';

final todayReservationProvider =
    StateNotifierProvider.autoDispose<TodayReservationProvider, ReservationModelBase?>(
  (ref) {
    final repository = ref.watch(todayReservationRepositoryProvider);
    return TodayReservationProvider(
      repository: repository,
    );
  },
);

class TodayReservationProvider extends StateNotifier<ReservationModelBase?> {
  final TodayReservationRespository repository;
  TodayReservationProvider({
    required this.repository,
  }) : super(ResrevationModelLoading()) {
    getTodayReservation();
  }

  Future<void> getTodayReservation() async {
    try {
      final result = await repository.getTodayReservation();
      state = result;
    } catch (e) {
      state = ResrevationModelError(
        message: e.toString(),
      );
    }
  }
}

final matchingProvider =
    StateNotifierProvider<MatchingPaginationProvider, OffsetPaginationBase>(
        (ref) {
  final repository = ref.read(matchingRepositoryProvider);
  return MatchingPaginationProvider(
    repository: Future(
      () => repository,
    ),
  );
});

class MatchingPaginationProvider
    extends PaginationBaseStateNotifier<MatchingModel, MatchingRepository> {
  MatchingPaginationProvider({
    required super.repository,
  });
}

final reservationProvider =
    StateNotifierProvider<ReservationPaginationProvider, OffsetPaginationBase>(
        (ref) {
  final repository = ref.read(reservationRepositoryProvider);
  return ReservationPaginationProvider(
    repository: Future(
      () => repository,
    ),
  );
});

class ReservationPaginationProvider extends PaginationBaseStateNotifier<
    ReservationModel, ReservationRepository> {
  ReservationPaginationProvider({
    required super.repository,
  });
}
