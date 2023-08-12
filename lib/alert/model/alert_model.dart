import 'package:jari_bean/common/models/model_with_id.dart';

class AlertModel implements IModelWithId {
  @override
  String id;
  final String title;
  final String description;
  final String buttonTitle;
  final String image;

  AlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.buttonTitle,
    required this.image,
  });
}
