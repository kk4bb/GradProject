class Quiz {
  final int id;
  final String title;
  final int questionCount;

  Quiz({
    required this.id,
    required this.title,
    required this.questionCount,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      questionCount: json['questionCount'] ?? 0,
    );
  }
}

class QuizTake {
  final int id;
  final String title;
  final List<Question> questions;

  QuizTake({
    required this.id,
    required this.title,
    required this.questions,
  });

  factory QuizTake.fromJson(Map<String, dynamic> json) {
    return QuizTake(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      questions: (json['questions'] as List?)
              ?.map((e) => Question.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Question {
  final int id;
  final String text;
  final List<Option> options;

  Question({
    required this.id,
    required this.text,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      options: (json['options'] as List?)
              ?.map((e) => Option.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Option {
  final int id;
  final String text;

  Option({
    required this.id,
    required this.text,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
    );
  }
}

class QuizResult {
  final double score;
  final int totalQuestions;
  final int correctAnswersCount;

  QuizResult({
    required this.score,
    required this.totalQuestions,
    required this.correctAnswersCount,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      totalQuestions: json['totalQuestions'] ?? 0,
      correctAnswersCount: json['correctAnswersCount'] ?? 0,
    );
  }
}
