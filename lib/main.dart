import 'package:flutter/material.dart';
import 'my_app.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await NotificationService.scheduleDailyReminder();
  runApp(MyApp());
}

