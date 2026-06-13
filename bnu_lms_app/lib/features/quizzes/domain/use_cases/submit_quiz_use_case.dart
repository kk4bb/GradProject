import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../entities/quiz_attempt_entity.dart';
import '../repositories/quiz_repository.dart';

@lazySingleton
class SubmitQuizUseCase {
  final QuizRepository repository;

  SubmitQuizUseCase(this.repository);

  Future<Either<Failure, QuizAttemptEntity>> call(int quizId, Map<String, dynamic> submissionData) {
    return repository.submitQuiz(quizId, submissionData);
  }
}
