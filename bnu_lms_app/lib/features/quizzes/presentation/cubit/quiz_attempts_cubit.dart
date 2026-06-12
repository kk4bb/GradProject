import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/quiz_attempt_entity.dart';
import '../../domain/use_cases/get_quiz_attempts_use_case.dart';

abstract class QuizAttemptsState {}
class QuizAttemptsInitial extends QuizAttemptsState {}
class QuizAttemptsLoading extends QuizAttemptsState {}
class QuizAttemptsLoaded extends QuizAttemptsState {
  final List<QuizAttemptEntity> attempts;
  QuizAttemptsLoaded(this.attempts);
}
class QuizAttemptsError extends QuizAttemptsState {
  final String message;
  QuizAttemptsError(this.message);
}

@injectable
class QuizAttemptsCubit extends Cubit<QuizAttemptsState> {
  final GetQuizAttemptsUseCase getQuizAttemptsUseCase;

  QuizAttemptsCubit(this.getQuizAttemptsUseCase) : super(QuizAttemptsInitial());

  Future<void> fetchAttempts(int quizId) async {
    emit(QuizAttemptsLoading());
    final result = await getQuizAttemptsUseCase(quizId);
    result.fold(
      (failure) {
        if (!isClosed) emit(QuizAttemptsError(failure.message));
      },
      (attempts) {
        if (!isClosed) emit(QuizAttemptsLoaded(attempts));
      },
    );
  }
}
