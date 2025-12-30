import 'package:flutter/material.dart';
import 'main_container.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final List<Color> colors = [
    const Color.fromARGB(255, 187, 167, 180),
    const Color.fromRGBO(220,220,235, 1),
    const Color.fromARGB(255, 183, 203, 221),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('LiveLearn Feedback')),
        body: MainContainer(colors),
      ),
    );
  }
}
