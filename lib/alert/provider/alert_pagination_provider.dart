import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/model/alert_model.dart';
import 'package:jari_bean/alert/provider/alert_provider.dart';
import 'package:jari_bean/alert/repository/alert_repository.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/provider/pagination_base_provider.dart';

final alertPaginationProvider =
    StateNotifierProvider<AlertPaginationProvider, OffsetPaginationBase>((ref) {
  final repository = ref.read(alertRepositoryProvider);
  final provider = ref.read(alertProvider.notifier);
  return AlertPaginationProvider(
    alertProvider: provider,
    repository: repository,
  );
});

class AlertPaginationProvider
    extends PaginationBaseStateNotifier<AlertModel, AlertRepository> {
  final AlertStateNotifier alertProvider;
  AlertPaginationProvider({
    required this.alertProvider,
    required super.repository,
  }) : super() {
    alertPaginate();
  }

  alertPaginate({
    int fetchCount = 20,
    int page = 0,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) {
    alertProvider.getAlertsFromPagination(
      paginate(
        fetchCount: fetchCount,
        page: page,
        fetchMore: fetchMore,
        forceRefetch: forceRefetch,
      ),
    );
  }
}
