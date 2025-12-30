import 'package:flutter/material.dart';
import 'feedback_model.dart';
import 'api_service.dart';
import 'trend_chart.dart';
import 'notification_service.dart';

class MainText extends StatefulWidget {
  const MainText({super.key});

  @override
  State<MainText> createState() => _MainTextState();
}

class _MainTextState extends State<MainText> {
  List<FeedbackEntry> eintraege = [];

  int verstehen = 0;
  int tempo = 0;
  int engagement = 0;

  final extremCtrl = TextEditingController();
  final freiCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    initNotifications();
    loadFeedback();
  }

  void loadFeedback() async {
    try {
      final data = await ApiService.fetchFeedback();
      setState(() {
        eintraege = data;
      });
    } catch (_) {}
  }

  int durchschnitt(List<FeedbackEntry> list, String feld) {
    if (list.isEmpty) return 0;
    double summe = 0;
    for (var e in list) {
      if (feld == "verstehen") summe += e.verstehen;
      if (feld == "tempo") summe += e.tempo;
      if (feld == "engagement") summe += e.engagement;
    }
    return (summe / list.length).round();
  }

  String verbesserung(int alt, int neu) {
    if (neu > alt) return "↑ verbessert";
    if (neu < alt) return "↓ schlechter";
    return "→ gleich";
  }

  void showError() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Unvollständige Bewertung"),
        content: const Text(
          "Bitte bewerte alle Kriterien, bevor du speicherst.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget starRow(String title, int value, Function(int) onChange) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (i) {
            return IconButton(
              icon: Icon(
                i < value ? Icons.star : Icons.star_border,
                color: Colors.amber,
              ),
              onPressed: () => setState(() => onChange(i + 1)),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool extremeReached =
        verstehen == 1 || verstehen == 5 ||
        tempo == 1 || tempo == 5 ||
        engagement == 1 || engagement == 5;

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //DURCHSCHNITT
          Text(
            "Durchschnitt",
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("Verständlichkeit: ${durchschnitt(eintraege, "verstehen")}",
              style: const TextStyle(color: Colors.white)),
          Text("Tempo: ${durchschnitt(eintraege, "tempo")}",
              style: const TextStyle(color: Colors.white)),
          Text("Engagement: ${durchschnitt(eintraege, "engagement")}",
              style: const TextStyle(color: Colors.white)),

          if (eintraege.length >= 2) ...[
            const SizedBox(height: 6),
            Text(
              "Verständlichkeit: ${verbesserung(
                durchschnitt(eintraege.sublist(0, eintraege.length - 1), "verstehen"),
                durchschnitt(eintraege, "verstehen"),
              )}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Tempo: ${verbesserung(
                durchschnitt(eintraege.sublist(0, eintraege.length - 1), "tempo"),
                durchschnitt(eintraege, "tempo"),
              )}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Engagement: ${verbesserung(
                durchschnitt(eintraege.sublist(0, eintraege.length - 1), "engagement"),
                durchschnitt(eintraege, "engagement"),
              )}",
              style: const TextStyle(color: Colors.white),
            ),
          ],

          const SizedBox(height: 16),

          //TREND
          SizedBox(
            height: screenHeight * 0.3,
            child: TrendChart(eintraege),
          ),

          const Divider(color: Colors.white),

          //BEWERTUNG
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              starRow("Verständlichkeit", verstehen, (v) => setState(() => verstehen = v)),
              starRow("Tempo", tempo, (v) => setState(() => tempo = v)),
              starRow("Engagement", engagement, (v) => setState(() => engagement = v)),
            ],
          ),

          if (extremeReached)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: extremCtrl,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: "Kommentar (wegen Extremwert)",
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: freiCtrl,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: "Freitext (optional)",
              ),
              maxLines: null,
            ),
          ),

          ElevatedButton(
            onPressed: () async {
              if (verstehen == 0 || tempo == 0 || engagement == 0) {
                showError();
                return;
              }

              final entry = FeedbackEntry(
                date: DateTime.now(),
                verstehen: verstehen,
                tempo: tempo,
                engagement: engagement,
                extremKommentar: extremeReached ? extremCtrl.text : null,
                freiText: freiCtrl.text.isEmpty ? null : freiCtrl.text,
              );

              await ApiService.postFeedback(entry);

              setState(() {
                eintraege.add(entry);
                verstehen = 0;
                tempo = 0;
                engagement = 0;
                extremCtrl.clear();
                freiCtrl.clear();
              });

              //Sofort-Notification
                await showNotification(
                "Feedback gespeichert ✅",
                "Danke für dein Feedback zur aktuellen LV-Einheit!",
              );
            },
            child: const Text("Feedback speichern"),
          ),

          const Divider(color: Colors.white),

          //VERLAUF
          Text(
            "Bewertungsverlauf",
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(
            height: screenHeight * 0.3,
            child: ListView(
              children: eintraege.map((e) {
                return Card(
                  child: ListTile(
                    title: Text(
                      e.date.toString().substring(0, 16),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "V: ${e.verstehen}, T: ${e.tempo}, E: ${e.engagement}\n"
                      "Extrem: ${e.extremKommentar ?? '-'}\n"
                      "Frei: ${e.freiText ?? '-'}",
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
