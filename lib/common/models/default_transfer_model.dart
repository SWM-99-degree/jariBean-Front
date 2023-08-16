import 'package:json_annotation/json_annotation.dart';

part 'default_transfer_model.g.dart';

@JsonSerializable()
class DefualtTransferModel {
  final int code;
  final String msg;
  final dynamic data;

  DefualtTransferModel({
    required this.code,
    required this.msg,
    required this.data,
  });

  factory DefualtTransferModel.fromJson(Map<String, dynamic> json) =>
      _$DefualtTransferModelFromJson(json);
}
