import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/exception/custom_exception.dart';
import 'package:jari_bean/common/models/location_model.dart';
import 'package:jari_bean/common/provider/location_provider.dart';
import 'package:jari_bean/matching/model/matching_body_model.dart';
import 'package:jari_bean/matching/repository/matching_repository.dart';

final matchingHeadcountProvider =
    StateNotifierProvider<MatchingHeadcountStateNotifier, int>(
  (ref) => MatchingHeadcountStateNotifier(),
);

class MatchingHeadcountStateNotifier extends StateNotifier<int> {
  static const maxHeadcount = 6;
  static const minHeadcount = 1;
  MatchingHeadcountStateNotifier() : super(2);

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

final matchingProvider =
    StateNotifierProvider<MatchingStateNotifier, MatchingBodyModel>((ref) {
  final headcount = ref.watch(matchingHeadcountProvider);
  final location = ref.watch(locationProvider);
  final repository = ref.read(matchingRepositoryProvider);
  if (location is! LocationModel) {
    throw GPSException();
  }
  return MatchingStateNotifier(
    headcount: headcount,
    location: location,
    repository: repository,
  );
});

class MatchingStateNotifier extends StateNotifier<MatchingBodyModel> {
  final int headcount;
  final LocationModel location;
  final MatchingRepository repository;
  MatchingStateNotifier({
    required this.headcount,
    required this.location,
    required this.repository,
  }) : super(
          MatchingBodyModel(
            headCount: headcount,
            location: location,
          ),
        );

  Future<void> matching() async {
    try {
      await repository.matching(body: state);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw DuplicatedMatchingException();
      }
    } catch (e) {
      throw MatchingFailedException();
    }
  }

  Future<void> cancelMatchingInEnqueued(Function callback) async {
    try {
      await repository.cancelMatchingInEnqueued();
      callback();
    } catch (e) {
      throw MatchingFailedException();
    }
  }
}
