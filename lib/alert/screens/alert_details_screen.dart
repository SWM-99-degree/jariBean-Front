import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/provider/alert_provider.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';

class AlertDetailsScreen extends ConsumerWidget {
  static String get routerName => '/alert/:id';
  final String alertId;
  const AlertDetailsScreen({required this.alertId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alert = ref.watch(alertProvider.notifier).getAlertById(alertId);
    return DefaultLayout(
      title: alert.id,
      child: Column(
        children: [
          Text(alert.title),
        ],
      ),
    );
  }
}
