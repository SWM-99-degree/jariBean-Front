import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/layout/default_card_layout.dart';
import 'package:jari_bean/history/model/matching_model.dart';
import 'package:jari_bean/history/model/reservation_model.dart';

class HistoryScreen extends ConsumerWidget {
  static String get routerName => '/history';
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        DefaultCardLayout.fromMatchingModel(
          model: MatchingModel.fromJson({
            "id": "6503b645b723d27a6739687a",
            "seating": 3,
            "startTime": "2023-09-15T01:41:25.286",
            "cafeSummaryDto": {
              "id": "64fd48821a11b172e165f2fd",
              "name": "스타벅스 테헤란로아남타워점",
              "address": "아남타워빌딩 1층",
              "imageUrl": "https://picsum.photos/50/50"
            }
          }),
        ),
        DefaultCardLayout.fromReservationModel(
          model: ReservationModel.fromJson({
            "reserveId": "6503b645b723d27a6739687a",
            "reserveStartTime": "2023-09-15T01:41:25.286",
            "reserveEndTime": "2023-09-15T11:41:25.286",
            "matchingSeating": 3,
            "cafeSummaryDto": {
              "id": "64fd48821a11b172e165f2fd",
              "name": "스타벅스 테헤란로아남타워점",
              "address": "아남타워빌딩 1층",
              "imageUrl": "https://picsum.photos/50/50"
            }
          }),
        ),
      ],
    );
  }
}
