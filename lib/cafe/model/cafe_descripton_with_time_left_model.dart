import 'package:jari_bean/cafe/model/cafe_description_model.dart';

class CafeDescriptionWithTimeLeftModel extends CafeDescriptionModel {
  final int timeLeft;

  CafeDescriptionWithTimeLeftModel({
    required super.id,
    required super.title,
    required super.imgUrl,
    required super.cafeAddress,
    required this.timeLeft,
  });

  CafeDescriptionWithTimeLeftModel updateTimeLeft({
    required int nextTimeLeft,
  }) {
    return CafeDescriptionWithTimeLeftModel(
        id: id,
        title: title,
        imgUrl: imgUrl,
        cafeAddress: cafeAddress,
        timeLeft: nextTimeLeft);
  }
}
