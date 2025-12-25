import 'dart:convert';
import 'package:http/http.dart' as http;
import 'feedback_model.dart';

class ApiService {
  static const String baseUrl =
      'https://6946bc09ca6715d122f8c129.mockapi.io/feedback';

  static Future<List<FeedbackEntry>> fetchFeedback() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data.map((json) {
        return FeedbackEntry(
          date: DateTime.parse(json['date']),
          verstehen: json['verstehen'],
          tempo: json['tempo'],
          engagement: json['engagement'],
          extremKommentar: json['extremKommentar'],
          freiText: json['freiText'],
        );
      }).toList();
    } else {
      throw Exception('Fehler beim Laden der Feedbacks');
    }
  }

  static Future<void> postFeedback(FeedbackEntry entry) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'date': entry.date.toIso8601String(),
        'verstehen': entry.verstehen,
        'tempo': entry.tempo,
        'engagement': entry.engagement,
        'extremKommentar': entry.extremKommentar,
        'freiText': entry.freiText,
      }),
    );
  }
}
