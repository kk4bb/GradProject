class QuizAttemptModel {
  final int id;
  final int quizId;
  final String title;
  final String studentId;
  final String? studentName;
  final double score;
  final String? essayAnswer;
  final double? manualScore;
  final String status;

  QuizAttemptModel({
    required this.id,
    required this.quizId,
    required this.title,
    required this.studentId,
    this.studentName,
    required this.score,
    this.essayAnswer,
    this.manualScore,
    required this.status,
  });

  factory QuizAttemptModel.fromJson(Map<String, dynamic> json) {
    return QuizAttemptModel(
      id: json['id'] ?? 0,
      quizId: json['quizId'] ?? 0,
      title: json['title'] ?? '',
      studentId: json['studentId'] ?? '',
      studentName: json['studentName'],
      score: (json['score'] ?? 0).toDouble(),
      essayAnswer: json['essayAnswer'],
      manualScore: json['manualScore'] != null ? (json['manualScore']).toDouble() : null,
      status: json['status'] ?? 'Completed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quizId': quizId,
      'title': title,
      'studentId': studentId,
      'studentName': studentName,
      'score': score,
      'essayAnswer': essayAnswer,
      'manualScore': manualScore,
      'status': status,
    };
  }
}
