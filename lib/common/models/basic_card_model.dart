import 'package:jari_bean/common/models/model_with_id.dart';

class BasicCardModel implements IModelWithId {
  @override
  final String id;
  final String title;
  final String? imgUrl;

  BasicCardModel({
    required this.id,
    required this.title,
    required this.imgUrl,
  });
}
