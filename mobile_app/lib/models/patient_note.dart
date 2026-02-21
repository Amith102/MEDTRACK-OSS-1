class PatientNote {
  final String id;
  final String patientId;
  final String title;
  final String content;
  final String category;
  final DateTime date;

  PatientNote({
    required this.id,
    required this.patientId,
    required this.title,
    required this.content,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'title': title,
      'content': content,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  factory PatientNote.fromJson(Map<String, dynamic> json) {
    return PatientNote(
      id: json['id'],
      patientId: json['patientId'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      date: DateTime.parse(json['date']),
    );
  }
}
