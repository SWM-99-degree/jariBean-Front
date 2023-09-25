import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/models/model_with_id.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/models/pagination_params.dart';
import 'package:jari_bean/common/repository/pagination_base_repository.dart';

/// PaginationBaseStateNotifier is a StateNotifier that provides pagination.
/// It is used to provide pagination to the UI.
/// repository must be a Future of IPaginationBaseRepository because of the DB initialization issue.
/// pass two generics to PaginationBaseStateNotifier.
/// T is a type of IModelWithId.
/// U is a type of IPaginationBaseRepository.
class PaginationBaseStateNotifier<T extends IModelWithId,
        U extends IPaginationBaseRepository<T>>
    extends StateNotifier<OffsetPaginationBase> {
  final Future<U> repository;
  PaginationBaseStateNotifier({
    required this.repository,
  }) : super(OffsetPaginationLoading()) {
    paginate();
  }

  Future<List<T>> paginate({
    int fetchCount = 20,
    int page = 0,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    try {
      if (state is OffsetPagination && !forceRefetch) {
        final pState = state as OffsetPagination;

        if (pState.last) return [];
      }

      final isLoading = state is OffsetPaginationLoading;
      final isRefetching = state is OffsetPaginationRefetching;
      final isFetchingMore = state is OffsetPaginationFetchingMore;
      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        print(isFetchingMore);
        return [];
      }

      PaginationParams paginationParams = PaginationParams(
        size: fetchCount,
        page: page,
      );

      if (fetchMore) {
        final pState = state as OffsetPagination<T>;
        state = OffsetPaginationFetchingMore<T>(
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
          final pState = state as OffsetPagination<T>;

          state = OffsetPaginationRefetching<T>(
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
        final pState = state as OffsetPaginationFetchingMore<T>;

        state = resp.copyWith(
          content: [
            ...pState.content,
            ...resp.content,
          ],
        );
      } else {
        state = resp;
      }

      return resp.content;
    } catch (e, stack) {
      state = OffsetPaginationError(message: '데이터 수신 실패!');
      print(e);
      print(stack);
    }
    return [];
  }
}
