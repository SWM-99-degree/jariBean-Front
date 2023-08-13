import 'package:jari_bean/common/models/basic_card_model.dart';

class CafeDescriptionModel extends BasicCardModel {
  String cafeAddress;

  CafeDescriptionModel({
    required super.id,
    required super.title,
    required super.imgUrl,
    required this.cafeAddress,
  });
}
