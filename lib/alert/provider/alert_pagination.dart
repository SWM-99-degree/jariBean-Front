import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/model/alert_model.dart';
import 'package:jari_bean/alert/repository/alert_repository.dart';
import 'package:jari_bean/common/models/fcm_message_model.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/models/pagination_params.dart';

final alertPaginationProvider =
    StateNotifierProvider<AlertPaginationProvider, OffsetPaginationBase>((ref) {
  final repository = ref.read(alertRepositoryProvider);
  return AlertPaginationProvider(
    repository: repository,
  );
});

final errorAlert = AlertModel(
  id: 'error',
  title: '에러가 발생했어요',
  isRead: false,
  body: '에러가 발생했어요',
  type: PushMessageType.announcement,
  receivedAt: DateTime.now(),
  data: FcmDataModelBase(),
);

class AlertPaginationProvider extends StateNotifier<OffsetPaginationBase> {
  final Future<AlertRepository> repository;
  AlertPaginationProvider({
    required this.repository,
  }) : super(OffsetPaginationLoading()) {
    paginate();
  }

  paginate({
    int fetchCount = 20,
    int page = 0,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    try {
      if (state is OffsetPagination && !forceRefetch) {
        final pState = state as OffsetPagination;

        if (pState.last) return;
      }

      final isLoading = state is OffsetPaginationLoading;
      final isRefetching = state is OffsetPaginationRefetching;
      final isFetchingMore = state is OffsetPaginationFetchingMore;
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        print(isFetchingMore);
        return;
      }

      PaginationParams paginationParams = PaginationParams(
        size: fetchCount,
        page: page,
      );

      if (fetchMore) {
        final pState = state as OffsetPagination<AlertModel>;
        state = OffsetPaginationFetchingMore<AlertModel>(
          content: pState.content,
          page: pState.page,
          last: pState.last,
        );

        paginationParams = paginationParams.copyWith(
          page: pState.page,
        );
      } else {
        if (state is OffsetPagination && !forceRefetch) {
          print('언제 수행??');
          final pState = state as OffsetPagination<AlertModel>;

          state = OffsetPaginationRefetching<AlertModel>(
            content: pState.content,
            page: pState.page,
            last: pState.last,
          );
        } else {
          state = OffsetPaginationLoading();
        }
      }

      final resp = await (await repository).paginate(
        paginationParams: paginationParams,
      );

      if (state is OffsetPaginationFetchingMore) {
        final pState = state as OffsetPaginationFetchingMore<AlertModel>;

        state = resp.copyWith(
          content: [
            ...pState.content,
            ...resp.content,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e, stack) {
      state = OffsetPaginationError(message: '데이터 수신 실패!');
      print(e);
      print(stack);
    }
  }

  add(AlertModel model) async {
    // duplicated id occurred
    if (state is OffsetPagination) {
      final pState = state as OffsetPagination<AlertModel>;
      state = pState.copyWith(
        content: [
          model,
          ...pState.content,
        ],
      );
    }
    await (await repository).insertAlert(model);
  }

  remove(AlertModel model) async {
    if (state is OffsetPagination) {
      final pState = state as OffsetPagination<AlertModel>;
      state = pState.copyWith(
        content: [
          ...pState.content.where((element) => element.id != model.id),
        ],
      );
    }
    await (await repository).deleteAlert(model.id);
  }
}
