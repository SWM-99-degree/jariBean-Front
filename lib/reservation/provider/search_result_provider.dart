import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/repository/cafe_repository.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/reservation/model/search_query_model.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';
import 'package:jari_bean/reservation/provider/search_text_provider.dart';

final searchResultProvider = StateNotifierProvider.autoDispose<
    SearchResultStateNotifier, OffsetPaginationBase>(
  (ref) {
    final repository = ref.watch(cafeRepositoryProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final searchQueryText = ref.watch(searchTextProvider);
    return SearchResultStateNotifier(
      repository: repository,
      searchQuery: searchQuery,
      searchQueryText: searchQueryText,
    );
  },
);

class SearchResultStateNotifier extends StateNotifier<OffsetPaginationBase> {
  final CafeRepository repository;
  final SearchQueryModel searchQuery;
  final String searchQueryText;
  SearchResultStateNotifier({
    required this.repository,
    required this.searchQuery,
    required this.searchQueryText,
  }) : super(OffsetPaginationLoading());

  Future<void> search() async {
    try {
      final searchQuery = this.searchQuery.copyWith(
            searchText: searchQueryText,
          );
      final result = await repository.search(searchQuery);
      state = result;
    } catch (e) {
      print(e);
      state = OffsetPaginationError(
        message: '카페를 불러오던 중 오류가 발생했습니다.',
      );
    }
  }
}
