import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/exception/custom_exception.dart';
import 'package:jari_bean/matching/repository/matching_repository.dart';
import 'package:jari_bean/reservation/provider/reservation_timer_provider.dart';

final matchingTimerProvider = StateNotifierProvider<TimerStateNotifier, int>(
  (ref) {
    return TimerStateNotifier();
  },
);

final matchingInfoProvider =
    StateNotifierProvider<MatchingInfoStateNotifier, MatchingInfoModel?>(
  (ref) {
    final repository = ref.read(matchingRepositoryProvider);
    return MatchingInfoStateNotifier(
      matchingId: '',
      cafeId: '',
      startTime: DateTime.now(),
      repository: repository,
    );
  },
);

class MatchingInfoStateNotifier extends StateNotifier<MatchingInfoModel?> {
  final String matchingId;
  final String cafeId;
  final DateTime startTime;
  final MatchingRepository repository;
  MatchingInfoStateNotifier({
    required this.matchingId,
    required this.cafeId,
    required this.startTime,
    required this.repository,
  }) : super(null) {
    if (matchingId == '') {
      state = null;
    } else {
      state = MatchingInfoModel(
        matchingId: matchingId,
        cafeId: cafeId,
        startTime: startTime,
      );
    }
  }

  void applyMatchingInfo({
    required String matchingId,
    required String cafeId,
    required DateTime startTime,
  }) {
    state = MatchingInfoModel(
      matchingId: matchingId,
      cafeId: cafeId,
      startTime: startTime,
    );
  }

  void resetMatchingInfo() {
    state = null;
  }

  Future<void> cancelMatched(Function callback) async {
    try {
      if (state == null) throw NotMatchedException();
      await repository.cancelMatchingInMatched(
        matchingId: {
          'matchingId': state!.matchingId,
        },
      );
      resetMatchingInfo();
      callback();
    } catch (e) {
      throw NotMatchedException();
    }
  }
}

class MatchingInfoModel {
  final String matchingId;
  final String cafeId;
  final DateTime startTime;
  MatchingInfoModel({
    required this.matchingId,
    required this.cafeId,
    required this.startTime,
  });

  MatchingInfoModel copyWith({
    String? matchingId,
    String? cafeId,
    DateTime? startTime,
  }) {
    return MatchingInfoModel(
      matchingId: matchingId ?? this.matchingId,
      cafeId: cafeId ?? this.cafeId,
      startTime: startTime ?? this.startTime,
    );
  }
}
