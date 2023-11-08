import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  final _notification = FlutterLocalNotificationsPlugin();

  Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future<void> init() async {
    final android = AndroidInitializationSettings('flutter_intro');
    final ios = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: ios);

    await _notification.initialize(settings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  Future showNotification(
          {int id = 0, String? title, String? body, String? payload}) async =>
      _notification.show(id, title, body, await _notificationDetails());
}
