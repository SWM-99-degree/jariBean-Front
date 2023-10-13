import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/user/models/user_model.dart';

final updateProfileProvider = StateNotifierProvider.autoDispose<
    UpdateProfileProvider, UpdateProfileModel>(
  (ref) => UpdateProfileProvider(),
);

class UpdateProfileProvider extends StateNotifier<UpdateProfileModel> {
  UpdateProfileProvider() : super(UpdateProfileModel());

  updateNickname({required String nickname}) async {
    state = state.copyWith(nickname: nickname);
  }

  updateDescription({required String description}) async {
    state = state.copyWith(description: description);
  }

  updateImgFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.image,
      );
      if (result != null) {
        state = state.copyWith(imgFile: result);
      }
    } catch (e) {
      print(e);
    }
  }
}
