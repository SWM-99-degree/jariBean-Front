import 'package:jari_bean/common/models/basic_card_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cafe_description_model.g.dart';

abstract class CafeDescriptionModelBase {}

class CafeDescriptionModelLoading extends CafeDescriptionModelBase {}

@JsonSerializable()
class CafeDescriptionModel extends CafeDescriptionModelBase implements BasicCardModel {
  @override
  @JsonKey(name: 'cafeId')
  final String id;
  @override
  @JsonKey(name: 'cafeName')
  final String title;
  @override
  @JsonKey(name: 'cafeImageUrl')
  final String imgUrl;
  final String cafeAddress;

  CafeDescriptionModel({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.cafeAddress,
  });

  factory CafeDescriptionModel.fromJson(Map<String, dynamic> json) =>
      _$CafeDescriptionModelFromJson(json);
}
