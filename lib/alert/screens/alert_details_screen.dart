import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/alert/provider/alert_announcement_provider.dart';
import 'package:jari_bean/alert/provider/alert_provider.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/common/style/default_font_style.dart';

class AlertDetailsScreen extends ConsumerWidget {
  static String get routerName => '/alert/:id';
  final String alertId;
  final bool isAnnouncement;
  const AlertDetailsScreen({
    required this.alertId,
    this.isAnnouncement = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late final String id;
    late final String title;
    late final String body;
    if (isAnnouncement) {
      final announcement = ref
          .watch(alertAnnouncementProvider.notifier)
          .getAnnouncementById(alertId);
      id = announcement.id;
      title = announcement.title;
      body = announcement.content;
    } else {
      final alert = ref.watch(alertProvider.notifier).getAlertById(alertId);
      id = alert.id;
      title = alert.title;
      body = alert.body;
    }
    return DefaultLayout(
      title: id,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: defaultFontStyleBlack.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.visible,
              ),
            ),
            SizedBox(height: 16),
            Text(
              body,
              style: defaultFontStyleBlack.copyWith(
                fontSize: 16,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
