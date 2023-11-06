// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http_parser/http_parser.dart';

part 'user_model.g.dart';

enum SocialLoginType { kakao, google, apple }

enum Role { UNREGISTERED, CUSTOMER, MANAGER }

abstract class UserModelBase {}

class UserModelError extends UserModelBase {
  final Object error;
  final String message;
  UserModelError(this.error, this.message);
}

class UserModelLoading extends UserModelBase {}

@JsonSerializable()
class UserModel extends UserModelBase {
  final String id;
  final String nickname;
  @JsonKey(name: 'socialId')
  final SocialLoginType? socialLoginType;
  @JsonKey(name: 'imageUrl')
  final String imgUrl;
  final String? description;
  final Role role;
  UserModel({
    required this.id,
    required this.nickname,
    required this.socialLoginType,
    required this.imgUrl,
    required this.description,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

class UpdateProfileModel {
  final String? nickname;
  final String? description;
  final FilePickerResult? imgFile;

  UpdateProfileModel({
    this.nickname,
    this.description,
    this.imgFile,
  });

  copyWith({
    String? nickname,
    String? description,
    FilePickerResult? imgFile,
  }) {
    return UpdateProfileModel(
      nickname: nickname ?? this.nickname,
      description: description ?? this.description,
      imgFile: imgFile ?? this.imgFile,
    );
  }

  FormData toFormData() {
    final formData = FormData();
    if (nickname != null) {
      formData.fields.add(MapEntry('username', nickname!));
    }
    if (description != null) {
      formData.fields.add(MapEntry('description', description!));
    }
    if (imgFile != null) {
      final fileName = imgFile!.files.first.name;
      final String fileExtension = imgFile!.files.first
          .extension!; // assume that selected file must have extension
      final file = MultipartFile.fromBytes(
        imgFile!.files.first.bytes!,
        filename: fileName,
        contentType: MediaType('image', fileExtension),
      );
      formData.files.add(MapEntry('image', file));
    }
    return formData;
  }
}
