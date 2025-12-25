class FeedbackEntry {
  final DateTime date;

  final int verstehen;
  final int tempo;
  final int engagement;

  final String? extremKommentar;
  final String? freiText;

  FeedbackEntry({
    required this.date,
    required this.verstehen,
    required this.tempo,
    required this.engagement,
    this.extremKommentar,
    this.freiText,
  });
}
