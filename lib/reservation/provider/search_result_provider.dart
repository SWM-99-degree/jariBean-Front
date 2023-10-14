import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/cafe/repository/cafe_repository.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/models/pagination_params.dart';
import 'package:jari_bean/common/provider/pagination_base_provider.dart';
import 'package:jari_bean/reservation/model/search_query_model.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';
import 'package:jari_bean/reservation/provider/search_text_provider.dart';

final searchResultProvider =
    StateNotifierProvider<SearchResultStateNotifier, OffsetPaginationBase>(
  (ref) {
    final repository = ref.watch(cafeRepositoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final searchQueryText = ref.watch(searchTextProvider);
    return SearchResultStateNotifier(
      repository: Future((() => repository)),
      searchQuery: searchQuery,
      searchQueryText: searchQueryText,
    );
  },
);

class SearchResultStateNotifier extends PaginationBaseStateNotifier<
    CafeDescriptionModel, CafeSearchResultRepository> {
  final SearchQueryModel searchQuery;
  final String searchQueryText;
  SearchResultStateNotifier({
    required this.searchQuery,
    required this.searchQueryText,
    required super.repository,
  }) {
    search();
  }

  /// searchQueryText is separated from searchQuery, so we need to merge them.
  SearchQueryModel mergeSearchQuery({
    required SearchQueryModel searchQuery,
    required String searchQueryText,
  }) {
    return searchQuery.copyWith(
      searchText: searchQueryText,
    );
  }

  Future<void> search({
    int fetchCount = 20,
    int page = 0,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    try {
      final query = mergeSearchQuery(
        searchQuery: searchQuery,
        searchQueryText: searchQueryText,
      );
      final paginateFunction = (await repository).paginateWithBody;
      paginate(
        fetchCount: fetchCount,
        page: page,
        fetchMore: fetchMore,
        forceRefetch: forceRefetch,
        paginate: ({
          required PaginationParams paginationParams,
        }) =>
            paginateFunction(
          paginationParams: paginationParams,
          body: query,
        ),
      );
    } catch (e) {
      print(e);
      state = OffsetPaginationError(
        message: '카페를 불러오던 중 오류가 발생했습니다.',
      );
    }
  }
}
