import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/model/alert_model.dart';
import 'package:jari_bean/alert/repository/alert_repository.dart';
import 'package:jari_bean/common/models/fcm_message_model.dart';

final alertProvider =
    StateNotifierProvider<AlertStateNotifier, List<AlertModel>>((ref) {
  final repository = ref.read(alertRepositoryProvider);
  final offset = ref.read(alertOffsetProvider.notifier);
  return AlertStateNotifier(
    repository: repository,
    offset: offset,
  );
});

class AlertStateNotifier extends StateNotifier<List<AlertModel>> {
  final Future<AlertRepository> repository;
  final StateController<int> offset;
  AlertStateNotifier({
    required this.repository,
    required this.offset,
  }) : super(
          [],
        );

  /// insert alert to the top of the list.
  /// this function is used when the user receives a new alert.
  /// if `AlertScreen` is not mounted, the alert will be inserted to the DB only, especially when fcm is received.
  Future<void> insert(AlertModel model) async {
    state = [
      model,
      ...state,
    ];
    try {
      await (await repository).insertAlert(model);
      offset.state++;
    } catch (e) {
      print('failed to insert alert to the DB.');
      print(e);
    }
  }

  /// delete alert from the list.
  /// this function is used when the user deletes an alert.
  /// if `AlertScreen` is not mounted, the alert will be deleted from the DB only.
  /// if the alert is not found in the list, it will be ignored.
  Future<void> delete(AlertModel model) async {
    try {
      state = [
        ...state.where((element) => element.id != model.id),
      ];
    } catch (e) {
      print('id : ${model.id} is not found in the list.');
      print(e);
    }
    try {
      await (await repository).deleteAlert(model.id);
      offset.state--;
    } catch (e) {
      print('failed to insert alert to the DB.');
      print(e);
    }
  }

  /// get alert by id from provider.
  /// this can only get alerts from the list.
  /// if you want to get alerts from the DB, use `AlertRepository.getAlertById`.
  /// if the alert is not found in the list, it will throw an error.
  /// ***must capsulate*** this function with `try-catch` block.
  AlertModel getAlertById(String id) {
    return state.firstWhere(
      (element) => element.id == id,
    );
  }

  Future<void> getAlertsFromPagination(Future<List<AlertModel>> alerts) async {
    state = [...state, ...(await alerts)];
  }

  Future<void> addAlertFromFcmMessage(FcmMessageModel message) async {
    if (state.any((element) => element.id == message.id)) {
      return;
    }

    final alert = AlertModel.fromFcmMessage(message);
    await insert(alert);
  }

  Future<void> markAsRead(String id) async {
    try {
      final alert = getAlertById(id);
      alert.isRead = true;
      state = [...state];

      final repository = await this.repository;
      await repository.markAsRead(id);
    } catch (e) {
      print(e);
    }
  }
}

final alertOffsetProvider = StateProvider<int>((ref) {
  return 0;
});
