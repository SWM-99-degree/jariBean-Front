import 'package:jari_bean/history/model/matching_model.dart';

void main() {
  final model = MatchingModel.fromJson({
    "id": "6503b645b723d27a6739687a",
    "seating": 3,
    "startTime": "2023-09-15T01:41:25.286",
    "cafeSummaryDto": {
      "id": "64fd48821a11b172e165f2fd",
      "name": "스타벅스 테헤란로아남타워점",
      "address": "아남타워빌딩 1층",
      "imageUrl": "https://picsum.photos/50/50"
    }
  });
  print(model);
}
