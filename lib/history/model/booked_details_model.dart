import 'package:jari_bean/history/model/history_model.dart';

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
      startTime: model.startTime,
      endTime: null,
      headCount: model.headCount,
    );
  }

  factory BookedDetailsModel.fromReservationModel({
    required ReservationModel model,
  }) {
    return BookedDetailsModel(
      startTime: model.startTime,
      endTime: model.endTime,
      headCount: model.headCount,
    );
  }

  factory BookedDetailsModel.fromHistoryModel({
    required IHistoryModelBase model,
  }) {
    if (model is ReservationModel) {
      return BookedDetailsModel(
        startTime: model.startTime,
        endTime: model.endTime,
        headCount: model.headCount,
      );
    }
    return BookedDetailsModel(
      startTime: model.startTime,
      endTime: null,
      headCount: model.headCount,
    );
  }
}
