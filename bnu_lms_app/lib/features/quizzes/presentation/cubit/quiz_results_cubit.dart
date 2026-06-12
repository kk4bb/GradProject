import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/quiz_attempt_entity.dart';
import '../../domain/use_cases/get_student_attempt_use_case.dart';

abstract class QuizResultsState {}
class QuizResultsInitial extends QuizResultsState {}
class QuizResultsLoading extends QuizResultsState {}
class QuizResultsLoaded extends QuizResultsState {
  final QuizAttemptEntity attempt;
  QuizResultsLoaded(this.attempt);
}
class QuizResultsError extends QuizResultsState {
  final String message;
  QuizResultsError(this.message);
}

@injectable
class QuizResultsCubit extends Cubit<QuizResultsState> {
  final GetStudentAttemptUseCase _getStudentAttemptUseCase;

  QuizResultsCubit(this._getStudentAttemptUseCase) : super(QuizResultsInitial());

  Future<void> fetchResults(int quizId) async {
    emit(QuizResultsLoading());
    final result = await _getStudentAttemptUseCase(quizId);
    
    result.fold(
      (failure) {
        if (!isClosed) emit(QuizResultsError(failure.message));
      },
      (attempt) {
        if (!isClosed) emit(QuizResultsLoaded(attempt));
      },
    );
  }
}
