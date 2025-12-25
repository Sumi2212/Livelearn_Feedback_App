import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'feedback_model.dart';

class TrendChart extends StatelessWidget {
  final List<FeedbackEntry> entries;

  const TrendChart(this.entries, {super.key});

  List<FlSpot> _spots(int Function(FeedbackEntry e) value) {
    return List.generate(entries.length, (i) {
      return FlSpot(i.toDouble(), value(entries[i]).toDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (entries.length < 2) {
      return const Text(
        "Zu wenige Daten für Trenddarstellung",
        style: TextStyle(color: Colors.white),
      );
    }

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: 1,
          maxY: 5,
          titlesData: FlTitlesData(show: false),
          gridData: FlGridData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: _spots((e) => e.verstehen),
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
            ),
            LineChartBarData(
              spots: _spots((e) => e.tempo),
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
            ),
            LineChartBarData(
              spots: _spots((e) => e.engagement),
              isCurved: true,
              color: Colors.orange,
              barWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
