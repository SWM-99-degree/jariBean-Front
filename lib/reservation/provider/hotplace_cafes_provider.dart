import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/provider/pagination_base_provider.dart';
import 'package:jari_bean/history/repository/history_repository.dart';
import 'package:jari_bean/reservation/repository/hotplace_cafes_repository.dart';

final hotplaceCafesPreviewProvider = StateNotifierProvider<
    HotplaceCafesPreviewStateNotifier, OffsetPaginationBase>(
  (ref) {
    final repository = ref.watch(homeRepositoryProvider);
    return HotplaceCafesPreviewStateNotifier(
      repository: repository,
    );
  },
);

class HotplaceCafesPreviewStateNotifier
    extends StateNotifier<OffsetPaginationBase> {
  final HomeRepository repository;
  HotplaceCafesPreviewStateNotifier({
    required this.repository,
  }) : super(OffsetPaginationLoading()) {
    getHotplaceCafesPreview();
  }

  Future<void> getHotplaceCafesPreview() async {
    try {
      final result = await repository.getHotplaceCafesPreview();
      state = result;
    } catch (e) {
      state = OffsetPaginationError(
        message: e.toString(),
      );
    }
  }
}

final hotplaceCafesProvider =
    StateNotifierProvider<HotplaceCafesStateNotifier, OffsetPaginationBase>(
  (ref) {
    final repository = ref.watch(hotplaceCafesRepositoryProvider);
    return HotplaceCafesStateNotifier(
      repository: Future((() => repository)),
    );
  },
);

class HotplaceCafesStateNotifier extends PaginationBaseStateNotifier<
    CafeDescriptionModel, HotplaceCafesRepository> {
  HotplaceCafesStateNotifier({
    required super.repository,
  });
}
