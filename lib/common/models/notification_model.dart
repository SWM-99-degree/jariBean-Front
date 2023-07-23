import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationModelBase{}

class NotificationModelLoading extends NotificationModelBase{}

class NotificationModel extends NotificationModelBase{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  NotificationModel(this.flutterLocalNotificationsPlugin);
}

class NotificationModelError extends NotificationModelBase{
  final Object error;
  final String errorDescription;

  NotificationModelError(this.error, this.errorDescription);
}