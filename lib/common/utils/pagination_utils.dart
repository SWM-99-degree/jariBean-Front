import 'package:flutter/material.dart';
import 'package:jari_bean/alert/provider/alert_pagination_provider.dart';
import 'package:jari_bean/common/models/model_with_id.dart';
import 'package:jari_bean/common/provider/pagination_base_provider.dart';
import 'package:jari_bean/common/repository/pagination_base_repository.dart';

class PaginationUtils {
  static void scrollListener({
    required ScrollController scrollController,
    required PaginationBaseStateNotifier<IModelWithId,
            IPaginationBaseRepository<IModelWithId>>
        provider,
  }) {
    if (scrollController.offset >
        scrollController.position.maxScrollExtent - 300) {
      if (provider is AlertPaginationProvider) {
        // checking type of provider to call different method. espacially for alert screen.
        provider.alertPaginate(fetchMore: true);
      } else {
        provider.paginate(fetchMore: true);
      }
    }
  }
}
