class Assignment {
  final int id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isSubmitted;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isSubmitted,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: DateTime.parse(json['dueDate']),
      isSubmitted: json['isSubmitted'] ?? false,
    );
  }
}
