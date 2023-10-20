import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/model/cafe_detail_model.dart';
import 'package:jari_bean/cafe/repository/cafe_repository.dart';

final cafeInformationProvider = StateNotifierProvider.family
    .autoDispose<CafeInformationStateNotifier, CafeDetailModelBase, String>(
  (ref, cafeId) {
    final repository = ref.watch(cafeRepositoryProvider);
    return CafeInformationStateNotifier(
      repository: repository,
      cafeId: cafeId,
    );
  },
);

class CafeInformationStateNotifier extends StateNotifier<CafeDetailModelBase> {
  final CafeRepository repository;
  final String cafeId;
  CafeInformationStateNotifier({
    required this.repository,
    required this.cafeId,
  }) : super(CafeDetailModelLoading()) {
    getCafeInfo();
  }

  void getCafeInfo() async {
    try {
      final cafeInfo = await repository.getCafeInfo(cafeId);
      state = cafeInfo;
    } catch (e) {
      state = CafeDetailModelError(e.toString());
    }
  }
}
