class QuizTakeModel {
  final int id;
  final String title;
  final int durationMinutes;
  final List<QuestionTakeModel> questions;

  QuizTakeModel({
    required this.id,
    required this.title,
    required this.durationMinutes,
    required this.questions,
  });

  factory QuizTakeModel.fromJson(Map<String, dynamic> json) {
    return QuizTakeModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 0,
      questions: (json['questions'] as List?)?.map((q) => QuestionTakeModel.fromJson(q)).toList() ?? [],
    );
  }
}

class QuestionTakeModel {
  final int id;
  final String text;
  final String? imageUrl;
  final bool isEssay;
  final double points;
  final List<OptionTakeModel> options;

  QuestionTakeModel({
    required this.id,
    required this.text,
    this.imageUrl,
    required this.isEssay,
    this.points = 1.0,
    required this.options,
  });

  factory QuestionTakeModel.fromJson(Map<String, dynamic> json) {
    return QuestionTakeModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      imageUrl: json['imageUrl'],
      isEssay: json['isEssay'] ?? false,
      points: (json['points'] as num?)?.toDouble() ?? 1.0,
      options: (json['options'] as List?)?.map((o) => OptionTakeModel.fromJson(o)).toList() ?? [],
    );
  }
}

class OptionTakeModel {
  final int id;
  final String text;
  final bool isCorrect;

  OptionTakeModel({
    required this.id,
    required this.text,
    required this.isCorrect,
  });

  factory OptionTakeModel.fromJson(Map<String, dynamic> json) {
    return OptionTakeModel(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
    );
  }
}
