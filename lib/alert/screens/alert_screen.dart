import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/provider/alert_pagination_provider.dart';
import 'package:jari_bean/alert/provider/alert_provider.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';

class AlertScreen extends ConsumerStatefulWidget {
  static String get routerName => '/alert';
  const AlertScreen({super.key});

  @override
  ConsumerState<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends ConsumerState<AlertScreen> {
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
      final alerts = ref.read(alertPaginationProvider.notifier);
      alerts.alertPaginate(fetchMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final alerts = ref.watch(alertProvider);
    final alerts = ref.watch(alertPaginationProvider);

    if (alerts is OffsetPaginationError) {
      return DefaultLayout(
        title: '알림',
        child: Center(
          child: Text('에러가 발생했어요'),
        ),
      );
    }

    if (alerts is OffsetPaginationRefetching ||
        alerts is OffsetPaginationLoading) {
      return DefaultLayout(
        title: '알림',
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final op = alerts as OffsetPagination;
    // final list = op.content;
    final list = ref.watch(alertProvider);

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
          return Dismissible(
            key: Key(pItem.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              final alerts = ref.read(alertProvider.notifier);
              alerts.delete(pItem);
            },
            background: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            child: ListTile(
              title: Text(pItem.id),
              subtitle: Text(pItem.body),
              trailing: Text(pItem.receivedAt.toString()),
            ),
          );
        },
        separatorBuilder: (_, index) => SizedBox(height: 16.0),
      ),
    );
  }
}
