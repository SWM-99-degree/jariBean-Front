import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/reservation/model/reservation_detail_model.dart';

final reservationRepositoryProvider = Provider<ReservationRepository>((ref) {
  return ReservationRepository();
});

class ReservationRepository {
  Future<ReservationDetailModel> getUrgentReservation() {
    return Future.delayed(
      Duration(seconds: 1),
      () => ReservationDetailModel.fromJson({
        'reserveId': '1',
        'reserveTime': '2023-08-14 23:30:10',
        'reserveNumber': '1',
        'cafeSummaryDto': {
          'cafeId': '1',
          'cafeName': '카페 이름',
          'cafeAddress': '카페 주소',
          'cafeImageUrl': 'https://picsum.photos/250?image=9',
        },
      }),
    );
  }
}