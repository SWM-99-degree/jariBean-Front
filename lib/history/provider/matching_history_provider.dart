import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/history/model/history_model.dart';

final matchingHistoryProvider =
    StateNotifierProvider<MatchingHistoryStateNotifier, List<MatchingModel>>(
        (ref) {
  return MatchingHistoryStateNotifier();
});

class MatchingHistoryStateNotifier extends StateNotifier<List<MatchingModel>> {
  MatchingHistoryStateNotifier()
      : super([
          MatchingModel.fromJson({
            "id": "6503b645b723d27a6739687a",
            "headCount": 3,
            "startTime": "2023-09-25T01:41:25.286",
            "cafeSummaryDto": {
              "id": "64fd48821a11b172e165f2fd",
              "name": "스타벅스 테헤란로아남타워점",
              "address": "아남타워빌딩 1층",
              "imageUrl": "https://picsum.photos/50/50"
            }
          }),
          MatchingModel.fromJson({
            "id": "6503b645b723d27a6739687a",
            "headCount": 3,
            "startTime": "2023-09-15T01:41:25.286",
            "cafeSummaryDto": {
              "id": "64fd48821a11b172e165f2fd",
              "name": "스타벅스 테헤란로아남타워점",
              "address": "아남타워빌딩 1층",
              "imageUrl": "https://picsum.photos/50/50"
            }
          }),
          MatchingModel.fromJson({
            "id": "6503b645b723d27a6739687a",
            "headCount": 3,
            "startTime": "2023-09-15T01:41:25.286",
            "cafeSummaryDto": {
              "id": "64fd48821a11b172e165f2fd",
              "name": "스타벅스 테헤란로아남타워점",
              "address": "아남타워빌딩 1층",
              "imageUrl": "https://picsum.photos/50/50"
            }
          }),
          MatchingModel.fromJson({
            "id": "6503b645b723d27a6739687a",
            "headCount": 3,
            "startTime": "2023-09-05T21:41:25.286",
            "cafeSummaryDto": {
              "id": "64fd48821a11b172e165f2fd",
              "name": "스타벅스 테헤란로아남타워점",
              "address": "아남타워빌딩 1층",
              "imageUrl": "https://picsum.photos/50/50"
            }
          }),
          MatchingModel.fromJson({
            "id": "6503b645b723d27a6739687a",
            "headCount": 3,
            "startTime": "2023-09-15T01:41:25.286",
            "cafeSummaryDto": {
              "id": "64fd48821a11b172e165f2fd",
              "name": "스타벅스 테헤란로아남타워점",
              "address": "아남타워빌딩 1층",
              "imageUrl": "https://picsum.photos/50/50"
            }
          }),
        ]);

  void add(MatchingModel model) {
    state = [...state, model];
  }
}

final matchingBundlesProvider = StateNotifierProvider<
    MatchingDateBundlesStateNotifier, List<HistoryBundleByDateModel>>((ref) {
  final models = ref.watch(matchingHistoryProvider);
  return MatchingDateBundlesStateNotifier(
    models: models,
  );
});

class MatchingDateBundlesStateNotifier
    extends StateNotifier<List<HistoryBundleByDateModel>> {
  final List<MatchingModel> models;
  MatchingDateBundlesStateNotifier({
    required this.models,
  }) : super([]) {
    init();
  }

  void init() {
    final Map<DateTime, List<MatchingModel>> map = {};
    for (var model in models) {
      final date = DateTime(
        model.startTime.year,
        model.startTime.month,
        model.startTime.day,
        0,
        0,
        0,
      );
      if (map.containsKey(date)) {
        map[date] = [...map[date]!, model];
      } else {
        map[date] = [model];
      }
    }
    final List<HistoryBundleByDateModel> bundles = [];
    map.forEach((key, value) {
      bundles.add(HistoryBundleByDateModel(date: key, models: value));
    });
    state = [...bundles];
  }
}
