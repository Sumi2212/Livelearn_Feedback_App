import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(initSettings);
  }

  static Future<void> scheduleDailyReminder() async {
    const androidDetails = AndroidNotificationDetails(
      'feedback_channel',
      'LiveLearn Feedback',
      channelDescription: 'Erinnerung zur Feedbackabgabe',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.zonedSchedule(
      0,
      'LiveLearn Feedback',
      'Bitte gib dein Feedback zur heutigen LV ab 📚',
      _nextInstanceOfEvening(),
      details,

      // ✅ Pflichtparameter in neuen Versionen
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      // ✅ tägliche Wiederholung zur gleichen Uhrzeit
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOfEvening() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
  tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour, now.minute + 1);
;

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
