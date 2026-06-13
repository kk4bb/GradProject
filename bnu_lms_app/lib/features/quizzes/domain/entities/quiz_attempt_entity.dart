class QuizAttemptEntity {
  final int id;
  final int quizId;
  final String title;
  final String studentId;
  final String? studentName;
  final double score;
  final String? essayAnswer;
  final double? manualScore;
  final String status;

  QuizAttemptEntity({
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
}
