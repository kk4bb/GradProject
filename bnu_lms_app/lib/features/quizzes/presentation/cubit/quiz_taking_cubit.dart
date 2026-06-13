import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/use_cases/submit_quiz_use_case.dart';
import '../../domain/use_cases/get_quiz_for_taking_use_case.dart';
import '../../domain/entities/quiz_attempt_entity.dart';
import '../../domain/entities/quiz_take_entity.dart';

abstract class QuizTakingState {}
class QuizTakingInitial extends QuizTakingState {}
class QuizTakingSubmitting extends QuizTakingState {}
class QuizTakingLoaded extends QuizTakingState {
  final QuizTakeEntity quiz;
  QuizTakingLoaded(this.quiz);
}
class QuizTakingSubmitted extends QuizTakingState {
  final QuizAttemptEntity attempt;
  QuizTakingSubmitted(this.attempt);
}
class QuizTakingError extends QuizTakingState {
  final String message;
  QuizTakingError(this.message);
}

@injectable
class QuizTakingCubit extends Cubit<QuizTakingState> {
  final SubmitQuizUseCase submitQuizUseCase;
  final GetQuizForTakingUseCase getQuizForTakingUseCase;

  int currentQuestionIndex = 0;
  QuizTakeEntity? quizTakeEntity;

  QuizTakingCubit(this.submitQuizUseCase, this.getQuizForTakingUseCase) : super(QuizTakingInitial());

  Future<void> loadQuiz(int quizId) async {
    emit(QuizTakingSubmitting()); // Using as loading state for simplicity or add QuizTakingLoading
    final result = await getQuizForTakingUseCase(quizId);
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(QuizTakingError(failure.message));
      },
      (quiz) {
        if (isClosed) return;
        quizTakeEntity = quiz;
        emit(QuizTakingLoaded(quiz));
      },
    );
  }

  void nextQuestion() {
    if (quizTakeEntity != null && currentQuestionIndex < quizTakeEntity!.questions.length - 1) {
      currentQuestionIndex++;
      emit(QuizTakingLoaded(quizTakeEntity!));
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      currentQuestionIndex--;
      if (quizTakeEntity != null) {
        emit(QuizTakingLoaded(quizTakeEntity!));
      }
    }
  }

  Future<void> submitQuiz(int quizId, Map<String, dynamic> submissionData) async {
    emit(QuizTakingSubmitting());
    final result = await submitQuizUseCase(quizId, submissionData);
    result.fold(
      (failure) {
        if (isClosed) return;
        emit(QuizTakingError(failure.message));
      },
      (attempt) {
        if (isClosed) return;
        emit(QuizTakingSubmitted(attempt));
      },
    );
  }
}
