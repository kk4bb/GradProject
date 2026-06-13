class QuizModel {
  final int id;
  final String title;
  final String description;
  final int courseId;
  final bool areGradesPublished;
  final bool isAutoGraded;
  final DateTime startDate;
  final DateTime endDate;
  final int durationMinutes;
  final int questionCount;
  final double totalMarks;
  final bool hasAttempted;

  QuizModel({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.areGradesPublished,
    required this.isAutoGraded,
    required this.startDate,
    required this.endDate,
    required this.durationMinutes,
    required this.questionCount,
    this.totalMarks = 0.0,
    this.hasAttempted = false,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      courseId: json['courseId'] ?? 0,
      areGradesPublished: json['areGradesPublished'] ?? false,
      isAutoGraded: json['isAutoGraded'] ?? true,
      startDate: json['startDate'] != null 
          ? DateTime.parse(json['startDate'].toString().endsWith('Z') ? json['startDate'] : json['startDate'] + 'Z').toLocal() 
          : DateTime.now(),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate'].toString().endsWith('Z') ? json['endDate'] : json['endDate'] + 'Z').toLocal() 
          : DateTime.now().add(const Duration(days: 1)),
      durationMinutes: json['durationMinutes'] ?? 0,
      questionCount: json['questionCount'] ?? 0,
      totalMarks: (json['totalMarks'] as num?)?.toDouble() ?? (json['questionCount'] ?? 0) * 10.0,
      hasAttempted: json['hasAttempted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'courseId': courseId,
      'areGradesPublished': areGradesPublished,
      'isAutoGraded': isAutoGraded,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'durationMinutes': durationMinutes,
      'questionCount': questionCount,
      'totalMarks': totalMarks,
      'hasAttempted': hasAttempted,
    };
  }
}
