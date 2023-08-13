import 'package:jari_bean/common/models/model_with_id.dart';
import 'package:jari_bean/common/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_area_model.g.dart';

@JsonSerializable()
class ServiceAreaModel implements IModelWithId {
  @override
  String id;
  final String name;
  @JsonKey(fromJson: Utils.pathToUrl)
  final String imgUrl;

  ServiceAreaModel({
    required this.id,
    required this.name,
    required this.imgUrl,
  });

  factory ServiceAreaModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceAreaModelFromJson(json);
}
