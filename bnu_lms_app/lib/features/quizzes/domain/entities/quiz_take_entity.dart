class QuizTakeEntity {
  final int id;
  final String title;
  final int durationMinutes;
  final List<QuestionTakeEntity> questions;

  QuizTakeEntity({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.questions,
  });
}

class QuestionTakeEntity {
  final int id;
  final String text;
  final String? imageUrl;
  final bool isEssay;
  final double points;
  final List<OptionTakeEntity> options;

  QuestionTakeEntity({
    required this.id,
    required this.text,
    this.imageUrl,
    required this.isEssay,
    this.points = 1.0,
    required this.options,
  });
}

class OptionTakeEntity {
  final int id;
  final String text;
  final bool isCorrect;

  OptionTakeEntity({
    required this.id,
    required this.text,
    required this.isCorrect,
  });
}
