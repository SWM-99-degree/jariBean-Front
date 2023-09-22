import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/model/alert_model.dart';
import 'package:jari_bean/alert/provider/alert_pagination_provider.dart';
import 'package:jari_bean/alert/provider/alert_provider.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/common/models/model_with_id.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';
import 'package:jari_bean/common/provider/pagination_base_provider.dart';

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

  final PaginationWidgetBuilder<T> itemBuilder;
  const PaginationListView({
    required this.provider,
    required this.itemBuilder,
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
    _scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (_scrollController.offset >
        _scrollController.position.maxScrollExtent - 300) {
      final provider = ref.read(widget.provider.notifier);
      if (provider is AlertPaginationProvider) {
        // checking type of provider to call different method. espacially for alert screen.
        provider.alertPaginate(fetchMore: true);
      } else {
        provider.paginate(fetchMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);
    if (state is OffsetPaginationError) {
      return DefaultLayout(
        child: Center(
          child: Text('에러가 발생했어요'),
        ),
      );
    }

    if (state is OffsetPaginationRefetching ||
        state is OffsetPaginationLoading) {
      return DefaultLayout(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final op = state as OffsetPagination<T>;
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
        controller: _scrollController,
        itemCount: list.length + 1,
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
