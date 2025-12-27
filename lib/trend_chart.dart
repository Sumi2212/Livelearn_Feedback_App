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

    // Dynamische Breite: 60px pro Eintrag oder min. Bildschirmbreite
    double chartWidth = entries.length * 60.0;
    double screenWidth = MediaQuery.of(context).size.width;
    if (chartWidth < screenWidth) chartWidth = screenWidth;

    return SizedBox(
      height: 220,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: chartWidth,
          child: LineChart(
            LineChartData(
              minY: 1,
              maxY: 5,
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      if (index < entries.length) {
                        return Text(
                          "${index + 1}", // Einheit 1,2,3...
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        );
                      }
                      return const Text("");
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 1),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: _spots((e) => e.verstehen),
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
                LineChartBarData(
                  spots: _spots((e) => e.tempo),
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
                LineChartBarData(
                  spots: _spots((e) => e.engagement),
                  isCurved: true,
                  color: Colors.orange,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
