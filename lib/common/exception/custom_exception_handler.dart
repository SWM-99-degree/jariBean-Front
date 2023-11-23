import 'package:jari_bean/common/component/custom_dialog.dart';
import 'package:jari_bean/common/exception/custom_exception.dart';
import 'package:jari_bean/common/provider/go_router_provider.dart';

class CustomExceptionHandler {
  static hanldeException(dynamic error) {
    if (error is CustomException) {
      showCustomDialog(
        context: rootNavigatorKey.currentContext!,
        model: error.dialogModel,
      )();
    } else if (error is Exception) {
      print(error);
    } else {
      print(error);
    }
  }
}
