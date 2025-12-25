import 'package:flutter/material.dart';
import 'main_container.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final List<Color> colors = [
    const Color.fromRGBO(232,209,224, 1),
    const Color.fromRGBO(220,220,235, 1),
    const Color.fromRGBO(216,231,245, 1),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('LiveLearn Feedback')),
        body: MainContainer(colors),
      ),
    );
  }
}
