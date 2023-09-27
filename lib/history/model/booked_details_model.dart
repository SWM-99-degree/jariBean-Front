import 'package:jari_bean/history/model/matching_model.dart';
import 'package:jari_bean/history/model/reservation_model.dart';

class BookedDetailsModel {
  final DateTime startTime;
  final DateTime? endTime;
  final int headCount;

  BookedDetailsModel({
    required this.startTime,
    required this.endTime,
    required this.headCount,
  });

  factory BookedDetailsModel.fromMatchingModel({
    required MatchingModel model,
  }) {
    return BookedDetailsModel(
      startTime: model.matchingStartTime,
      endTime: null,
      headCount: model.matchingHeadCount,
    );
  }

  factory BookedDetailsModel.fromReservationModel({
    required ReservationModel model,
  }) {
    return BookedDetailsModel(
      startTime: model.reservationStartTime,
      endTime: model.reservationEndTime,
      headCount: model.reservationHeadCount,
    );
  }
}
