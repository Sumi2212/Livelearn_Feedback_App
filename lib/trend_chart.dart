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
        style: TextStyle(color: Colors.white70),
      );
    }

    // Dynamische Breite: 60px pro Eintrag oder min. Bildschirmbreite
    double chartWidth = entries.length * 60.0;
    double screenWidth = MediaQuery.of(context).size.width;
    if (chartWidth < screenWidth) chartWidth = screenWidth;

    return SizedBox(
      height: 300,
      child: Card(
        color: const Color(0xFFF9FAFB),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //LEGENDE
              _legend(),

              const SizedBox(height: 12),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: chartWidth,
                    child: LineChart(_chartData()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== CHART DATA =====================

  LineChartData _chartData() {
    return LineChartData(
      minY: 0.5,
      maxY: 5.5,

      //Rahmen
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),

      //Grid
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.shade200,
          strokeWidth: 1,
        ),
      ),

      //Achsen
      titlesData: FlTitlesData(
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 28,
            getTitlesWidget: (value, meta) => Text(
              value.toInt().toString(),
              style: const TextStyle(
                color: Color.fromARGB(255, 63, 63, 63),
                fontSize: 12,
              ),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 26,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index < entries.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    "${index + 1}",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 97, 97, 97),
                      fontSize: 11,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),

      //Linien
      lineBarsData: [
        _line(
          color: Colors.blueAccent,
          value: (e) => e.verstehen,
        ),
        _line(
          color: Colors.greenAccent,
          value: (e) => e.tempo,
        ),
        _line(
          color: Colors.orangeAccent,
          value: (e) => e.engagement,
        ),
      ],
    );
  }

  // ===================== LINE STYLE =====================

  LineChartBarData _line({
    required Color color,
    required int Function(FeedbackEntry e) value,
  }) {
    return LineChartBarData(
      spots: _spots(value),
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,

      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, bar, index) =>
            FlDotCirclePainter(
          radius: 4,
          color: color,
          strokeWidth: 1.5,
          strokeColor: Colors.black,
        ),
      ),
    );
  }

  // ===================== LEGENDE =====================

  Widget _legend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _LegendItem(
          color: Colors.blueAccent,
          label: "Verständnis",
        ),
        _LegendItem(
          color: Colors.greenAccent,
          label: "Tempo",
        ),
        _LegendItem(
          color: Colors.orangeAccent,
          label: "Engagement",
        ),
      ],
    );
  }
}

// ===================== LEGENDE ITEM =====================

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: Color.fromARGB(179, 62, 62, 62),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
