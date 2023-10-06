import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/utils/utils.dart';

final dateDiscriminatorProvider =
    StateNotifierProvider<DateDiscriminatorStateNotifier, Map<String, bool>>(
        (ref) {
  return DateDiscriminatorStateNotifier();
});

class DateDiscriminatorStateNotifier extends StateNotifier<Map<String, bool>> {
  DateDiscriminatorStateNotifier() : super({});

  void addDate(DateTime date) {
    state = {
      ...state,
      Utils.getYYYYMMDDfromDateTime(date): true,
    };
  }

  void removeDate(DateTime date) {
    state = {
      ...state,
      Utils.getYYYYMMDDfromDateTime(date): false,
    };
  }

  bool isIn(DateTime date) {
    return state[Utils.getYYYYMMDDfromDateTime(date)] ?? false;
  }
}
