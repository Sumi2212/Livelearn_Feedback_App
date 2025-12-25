import 'package:flutter/material.dart';
import 'feedback_model.dart';

class FeedbackForm extends StatefulWidget {
  final Function(FeedbackEntry) onSave;

  const FeedbackForm({super.key, required this.onSave});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  int verstehen = 0;
  int tempo = 0;
  int engagement = 0;

  final extremCtrl = TextEditingController();
  final freiCtrl = TextEditingController();

  bool get extremeReached =>
      verstehen == 1 || verstehen == 5 ||
      tempo == 1 || tempo == 5 ||
      engagement == 1 || engagement == 5;

  Widget stars(int current, Function(int) setValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        return IconButton(
          icon: Icon(
            i < current ? Icons.star : Icons.star_border,
            color: Colors.yellowAccent,
          ),
          onPressed: () => setState(() => setValue(i + 1)),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text("Verständlichkeit", style: TextStyle(color: Colors.white)),
        stars(verstehen, (v) => verstehen = v),

        Text("Tempo", style: TextStyle(color: Colors.white)),
        stars(tempo, (v) => tempo = v),

        Text("Engagement", style: TextStyle(color: Colors.white)),
        stars(engagement, (v) => engagement = v),

        if (extremeReached)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: extremCtrl,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                labelText: "Kommentar (wegen Extremwert)",
              ),
            ),
          ),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: freiCtrl,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: "Freitext (optional)",
            ),
          ),
        ),

        ElevatedButton(
          onPressed: () {
            widget.onSave(
              FeedbackEntry(
                date: DateTime.now(),
                verstehen: verstehen,
                tempo: tempo,
                engagement: engagement,
                extremKommentar: extremeReached ? extremCtrl.text : null,
                freiText: freiCtrl.text.isEmpty ? null : freiCtrl.text,
              ),
            );
          },
          child: Text("Speichern"),
        ),
      ],
    );
  }
}
