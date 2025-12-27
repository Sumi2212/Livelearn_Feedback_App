import 'package:flutter/material.dart';
import 'package:livelearn_feedback_app/my_app.dart';
import 'package:livelearn_feedback_app/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  runApp(MyApp());
}
