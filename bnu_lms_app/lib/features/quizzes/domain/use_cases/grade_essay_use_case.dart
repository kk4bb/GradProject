import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../repositories/quiz_repository.dart';

@lazySingleton
class GradeEssayUseCase {
  final QuizRepository repository;

  GradeEssayUseCase(this.repository);

  Future<Either<Failure, bool>> call(int quizId, int attemptId, double manualScore) {
    return repository.gradeEssay(quizId, attemptId, manualScore);
  }
}
