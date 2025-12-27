import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

bool initialized = false;

Future<void> initNotifications() async {
  if (initialized) return;

  tz.initializeTimeZones();

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings settings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(settings);

  initialized = true;
}

Future<void> showNotification(String title, String body) async {
  await initNotifications();
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
          'feedback_channel', 'Feedback Notifications',
          importance: Importance.max, priority: Priority.high);

  const NotificationDetails platformDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(0, title, body, platformDetails);
}
