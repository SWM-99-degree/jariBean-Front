import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/model/alert_model.dart';
import 'package:jari_bean/alert/provider/alert_pagination_provider.dart';
import 'package:jari_bean/alert/provider/alert_provider.dart';
import 'package:jari_bean/common/component/pagination_list_view.dart';

class AlertScreen extends ConsumerWidget {
  const AlertScreen({super.key});
  static String get routerName => '/alert';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaginationListView<AlertModel>(
      provider: alertPaginationProvider,
      itemBuilder: (context, ref, index, model) {
        return Dismissible(
          key: Key(model.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            final provider = ref.read(alertProvider.notifier);
            provider.delete(model);
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
            title: Text(model.id),
            subtitle: Text(model.body),
            trailing: Text(model.receivedAt.toString()),
          ),
        );
      },
    );
  }
}
