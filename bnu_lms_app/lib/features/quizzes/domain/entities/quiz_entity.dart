class QuizEntity {
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
  final int attemptsAllowed;
  final int attemptsTaken;
  final List<Map<String, dynamic>>? creationQuestions;

  QuizEntity({
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
    this.attemptsAllowed = 1,
    this.attemptsTaken = 0,
    this.creationQuestions,
  });
}
