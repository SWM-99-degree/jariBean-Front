import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/model/alert_model.dart';
import 'package:jari_bean/alert/provider/alert_provider.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/common/models/model_with_id.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/provider/pagination_base_provider.dart';
import 'package:jari_bean/common/utils/pagination_utils.dart';
import 'package:jari_bean/reservation/provider/search_result_provider.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
  BuildContext context,
  WidgetRef ref,
  int index,
  T model,
);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationBaseStateNotifier, OffsetPaginationBase>
      provider;
  final bool
      isInsideNestedScrollView; // for nested scroll view. it will null controller inside listview.
  final PaginationWidgetBuilder<T> itemBuilder;
  const PaginationListView({
    required this.provider,
    required this.itemBuilder,
    this.isInsideNestedScrollView = false,
    super.key,
  });

  @override
  ConsumerState<PaginationListView> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId>
    extends ConsumerState<PaginationListView<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
      () => PaginationUtils.scrollListener(
        scrollController: _scrollController,
        provider: ref.read(widget.provider.notifier),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(
      () => PaginationUtils.scrollListener(
        scrollController: _scrollController,
        provider: ref.read(widget.provider.notifier),
      ),
    );
    _scrollController.dispose();
    super.dispose();
    if (T == CafeDescriptionModel) {
      print('dispose');
      ref.invalidate(searchResultProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);
    if (state is OffsetPaginationError) {
      return Center(
        child: Text('에러가 발생했어요'),
      );
    }

    if (state is OffsetPaginationRefetching ||
        state is OffsetPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    final op = state as OffsetPagination<T>;
    // this part is for specific model especially for modles that must be processed before rendering.
    if (T == AlertModel) {
      final list = ref.watch(alertProvider);
      return _listBuilder(
        op,
        list as List<T>,
      ); // since T is AlertModel and AlertModel is extends IModelWithId, it's safe to cast. but don't know why it's not working without casting.
    } else {
      return _listBuilder(op, op.content);
    }
  }

  Padding _listBuilder(
    OffsetPagination<T> op,
    List<T> list,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: widget.isInsideNestedScrollView ? null : _scrollController,
        itemCount: list.length + 1,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          if (index == list.length) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Center(
                child: op is OffsetPaginationFetchingMore
                    ? CircularProgressIndicator()
                    : Text('더이상 데이터가 없습니다'),
              ),
            );
          }
          final pItem = list[index];
          return widget.itemBuilder(context, ref, index, pItem);
        },
        separatorBuilder: (_, index) => SizedBox(height: 16.0),
      ),
    );
  }
}
