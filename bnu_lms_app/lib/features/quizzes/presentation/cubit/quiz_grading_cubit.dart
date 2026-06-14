import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/use_cases/grade_essay_use_case.dart';
import '../../domain/use_cases/publish_grades_use_case.dart';
import '../../domain/use_cases/create_quiz_use_case.dart';
import '../../domain/entities/quiz_entity.dart';

abstract class QuizGradingState {}
class QuizGradingInitial extends QuizGradingState {}
class QuizGradingLoading extends QuizGradingState {}
class QuizGradingSuccess extends QuizGradingState {
  final String message;
  QuizGradingSuccess(this.message);
}
class QuizGradingError extends QuizGradingState {
  final String message;
  QuizGradingError(this.message);
}

class QuizCreationDataUpdated extends QuizGradingState {
  final String title;
  final String duration;
  final List<Map<String, dynamic>> questions;
  QuizCreationDataUpdated(this.title, this.duration, this.questions);
}

@injectable
class QuizGradingCubit extends Cubit<QuizGradingState> {
  final GradeEssayUseCase gradeEssayUseCase;
  final PublishGradesUseCase publishGradesUseCase;
  final CreateQuizUseCase createQuizUseCase;

  // Quiz Creation State
  String creationTitle = '';
  String creationDescription = '';
  String creationDuration = '60';
  int? creationCourseId;
  DateTime? creationStartDate;
  DateTime? creationEndDate;
  bool creationAllowMultipleAttempts = false;
  List<Map<String, dynamic>> creationQuestions = [];

  QuizGradingCubit(this.gradeEssayUseCase, this.publishGradesUseCase, this.createQuizUseCase) : super(QuizGradingInitial());

  Future<void> gradeEssay(int quizId, int attemptId, double manualScore) async {
    emit(QuizGradingLoading());
    final result = await gradeEssayUseCase(quizId, attemptId, manualScore);
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(QuizGradingError(failure.message));
      },
      (success) {
        if (isClosed) return;
        emit(QuizGradingSuccess("Essay graded successfully."));
      },
    );
  }

  Future<void> publishGrades(int quizId) async {
    emit(QuizGradingLoading());
    final result = await publishGradesUseCase(quizId);
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(QuizGradingError(failure.message));
      },
      (success) {
        if (isClosed) return;
        emit(QuizGradingSuccess("Grades published successfully."));
      },
    );
  }

  // Mock methods for Quiz Creation Wizard (Publish / Save Draft)
  Future<void> publishQuiz() async {
    if (creationCourseId == null) {
      emit(QuizGradingError("Please select an associated course."));
      return;
    }
    emit(QuizGradingLoading());
    try {
      final quizEntity = QuizEntity(
        id: 0, // id is 0 for new quizzes
        title: creationTitle,
        description: creationDescription.isEmpty ? "Quiz Description" : creationDescription,
        courseId: creationCourseId!,
        areGradesPublished: false,
        isAutoGraded: true, // Assuming auto-graded by default or bind to UI if it exists
        startDate: creationStartDate ?? DateTime.now(),
        endDate: creationEndDate ?? DateTime.now().add(const Duration(days: 1)),
        durationMinutes: int.tryParse(creationDuration) ?? 60,
        questionCount: creationQuestions.length,
        attemptsAllowed: creationAllowMultipleAttempts ? 2 : 1,
        creationQuestions: creationQuestions,
      );

      final result = await createQuizUseCase(quizEntity);
      
      result.fold(
        (failure) {
          if (isClosed) return;
          emit(QuizGradingError(failure.message));
        },
        (createdQuiz) {
          if (isClosed) return;
          emit(QuizGradingSuccess("Quiz published successfully!"));
        }
      );
    } catch (e) {
      if (isClosed) return;
      emit(QuizGradingError(e.toString()));
    }
  }

  Future<void> saveDraft() async {
    emit(QuizGradingLoading());
    await Future.delayed(const Duration(seconds: 1));
    if (isClosed) return;
    emit(QuizGradingSuccess("Draft saved successfully."));
  }

  void updateQuizSettings(String title, String description, String duration, DateTime startDate, DateTime endDate, bool allowMultipleAttempts, {int? courseId}) {
    creationTitle = title;
    creationDescription = description;
    creationDuration = duration;
    creationStartDate = startDate;
    creationEndDate = endDate;
    creationAllowMultipleAttempts = allowMultipleAttempts;
    if (courseId != null) {
      creationCourseId = courseId;
    }
    emit(QuizCreationDataUpdated(creationTitle, creationDuration, creationQuestions));
  }

  void addQuestion(Map<String, dynamic> questionData) {
    creationQuestions.add(questionData);
    emit(QuizCreationDataUpdated(creationTitle, creationDuration, creationQuestions));
  }

  void removeQuestion(int index) {
    if (index >= 0 && index < creationQuestions.length) {
      creationQuestions.removeAt(index);
      emit(QuizCreationDataUpdated(creationTitle, creationDuration, creationQuestions));
    }
  }
}
