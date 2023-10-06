import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/provider/pagination_base_provider.dart';
import 'package:jari_bean/history/model/history_model.dart';
import 'package:jari_bean/history/repository/history_repository.dart';

final matchingProvider =
    StateNotifierProvider<MatchingPaginationProvider, OffsetPaginationBase>(
        (ref) {
  final repository = ref.read(matchingRepositoryProvider);
  return MatchingPaginationProvider(
    repository: Future.delayed(
      Duration(seconds: 0),
      () => repository,
    ),
  );
});

class MatchingPaginationProvider
    extends PaginationBaseStateNotifier<MatchingModel, MatchingRepository> {
  MatchingPaginationProvider({
    required super.repository,
  });
}
