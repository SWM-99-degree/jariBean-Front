import 'package:jari_bean/cafe/model/cafe_description_model.dart';

class CafeDescriptionWithRatingModel extends CafeDescriptionModel {
  final double rating;

  CafeDescriptionWithRatingModel({
    required this.rating,
    required super.id,
    required super.title,
    required super.imgUrl,
    required super.cafeAddress,
  });
}
