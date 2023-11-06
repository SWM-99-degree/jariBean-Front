import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jari_bean/alert/component/alert_card.dart';
import 'package:jari_bean/alert/model/alert_model.dart';
import 'package:jari_bean/alert/provider/alert_announcement_provider.dart';
import 'package:jari_bean/alert/provider/alert_pagination_provider.dart';
import 'package:jari_bean/alert/provider/alert_provider.dart';
import 'package:jari_bean/common/component/pagination_list_view.dart';
import 'package:jari_bean/common/const/color.dart';

class AlertScreen extends ConsumerWidget {
  const AlertScreen({super.key});
  static String get routerName => '/alert';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topAnnouncement = ref.watch(topAnnouncementProvider);
    final Widget top = Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 8.h,
      ),
      margin: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
      ),
      decoration: ShapeDecoration(
        color: GRAY_1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: AlertCard.fromAnnouncementModel(
        model: topAnnouncement,
        onTap: () {
          context.go('/alert/announcement');
        },
      ),
    );
    return Column(
      children: [
        top,
        Expanded(
          child: PaginationListView<AlertModel>(
            provider: alertPaginationProvider,
            itemBuilder: (context, ref, index, model) {
              final Widget main = GestureDetector(
                onTap: () => context.go('/alert/${model.id}'),
                child: Dismissible(
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
                  child: AlertCard.fromAlertModel(model: model),
                ),
              );
              return main;
            },
          ),
        ),
      ],
    );
  }
}
