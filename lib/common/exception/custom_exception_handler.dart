import 'package:jari_bean/common/component/custom_dialog.dart';
import 'package:jari_bean/common/exception/custom_exception.dart';
import 'package:jari_bean/common/models/custom_button_model.dart';
import 'package:jari_bean/common/models/custom_dialog_model.dart';
import 'package:jari_bean/common/provider/go_router_provider.dart';

class CustomExceptionHandler {
  static hanldeException(dynamic error) {
    if (error is CustomException) {
      showCustomDialog(
        context: rootNavigatorKey.currentContext!,
        model: error.dialogModel,
      )();
    } else if (error is Exception) {
      showCustomDialog(
        context: rootNavigatorKey.currentContext!,
        model: CustomDialogModel(
          title: '오류',
          description: error.toString(),
          customButtonModel: CustomButtonModel(
            title: '확인',
          ),
        ),
      )();
    }
  }
}
