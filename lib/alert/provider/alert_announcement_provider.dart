import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/model/alert_announcement_model.dart';
import 'package:jari_bean/alert/repository/alert_announcement_repository.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/provider/pagination_base_provider.dart';

final alertAnnouncementProvider =
    StateNotifierProvider<AlertAnnouncementProvider, OffsetPaginationBase>(
        (ref) {
  final repository = ref.read(alertAnnouncementRepositoryProvider);
  return AlertAnnouncementProvider(repository: Future(() => repository));
});

class AlertAnnouncementProvider extends PaginationBaseStateNotifier<
    AlertAnnouncementModel, AlertAnnouncementRepository> {
  AlertAnnouncementProvider({
    required super.repository,
  });
}
