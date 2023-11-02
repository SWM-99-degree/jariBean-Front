import 'package:jari_bean/common/models/custom_button_model.dart';
import 'package:jari_bean/common/models/custom_dialog_model.dart';

class CustomException implements Exception {
  final String message;
  final CustomDialogModel dialogModel;

  CustomException({
    required this.message,
    required this.dialogModel,
  });

  @override
  String toString() {
    return 'error occurred : $message';
  }
}

class AccountDeleteException extends CustomException {
  AccountDeleteException()
      : super(
          message: '계정 삭제 중 오류가 발생했습니다.',
          dialogModel: CustomDialogModel(
            title: '계정 삭제 오류',
            description: '계정 삭제 중 오류가 발생했습니다.',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}

class NoInternetException extends CustomException {
  NoInternetException()
      : super(
          message: '인터넷 연결이 끊겼습니다.',
          dialogModel: CustomDialogModel(
            title: '인터넷 연결 오류',
            description: '인터넷 연결이 끊겼습니다.',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}

class AppleSocialLoginException extends CustomException {
  AppleSocialLoginException()
      : super(
          message: 'Apple 로그인 중 오류가 발생했습니다.',
          dialogModel: CustomDialogModel(
            title: 'Apple 로그인 오류',
            description: 'Apple 로그인 중 오류가 발생했습니다.',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}

class UnimplementedException extends CustomException {
  UnimplementedException()
      : super(
          message: '아직 준비중인 기능입니다.',
          dialogModel: CustomDialogModel(
            title: '알림',
            description: '아직 준비중인 기능이에요',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}
