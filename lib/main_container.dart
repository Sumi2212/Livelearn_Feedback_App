import 'package:flutter/material.dart';
import 'main_text.dart';

const startAlignment = Alignment.topCenter;
const endAlignment = Alignment.bottomCenter;

class MainContainer extends StatelessWidget {
  final List<Color> colors;

  const MainContainer(this.colors, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: startAlignment,
          end: endAlignment,
        ),
      ),
      child: Center(
        child: MainText(),
      ),
    );
  }
}
