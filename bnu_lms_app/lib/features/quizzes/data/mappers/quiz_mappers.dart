import '../../domain/entities/quiz_entity.dart';
import '../../domain/entities/quiz_attempt_entity.dart';
import '../models/quiz_model.dart';
import '../models/quiz_attempt_model.dart';
import '../models/quiz_take_model.dart';
import '../../domain/entities/quiz_take_entity.dart';

class QuizMappers {
  static QuizEntity toQuizEntity(QuizModel model) {
    return QuizEntity(
      id: model.id,
      title: model.title,
      description: model.description,
      courseId: model.courseId,
      areGradesPublished: model.areGradesPublished,
      isAutoGraded: model.isAutoGraded,
      startDate: model.startDate,
      endDate: model.endDate,
      durationMinutes: model.durationMinutes,
      questionCount: model.questionCount,
      totalMarks: model.totalMarks,
      hasAttempted: model.hasAttempted,
    );
  }

  static QuizAttemptEntity toQuizAttemptEntity(QuizAttemptModel model) {
    return QuizAttemptEntity(
      id: model.id,
      quizId: model.quizId,
      title: model.title,
      studentId: model.studentId,
      studentName: model.studentName,
      score: model.score,
      essayAnswer: model.essayAnswer,
      manualScore: model.manualScore,
      status: model.status,
    );
  }

  static QuizTakeEntity toQuizTakeEntity(QuizTakeModel model) {
    return QuizTakeEntity(
      id: model.id,
      title: model.title,
      durationMinutes: model.durationMinutes,
      questions: model.questions.map((q) => QuestionTakeEntity(
        id: q.id,
        text: q.text,
        imageUrl: q.imageUrl,
        isEssay: q.isEssay,
        points: q.points,
        options: q.options.map((o) => OptionTakeEntity(
          id: o.id,
          text: o.text,
          isCorrect: o.isCorrect,
        )).toList(),
      )).toList(),
    );
  }
}
