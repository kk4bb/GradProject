import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error/failure.dart';
import '../entities/quiz_attempt_entity.dart';
import '../repositories/quiz_repository.dart';

@injectable
class GetStudentAttemptUseCase {
  final QuizRepository repository;

  GetStudentAttemptUseCase(this.repository);

  Future<Either<Failure, QuizAttemptEntity>> call(int quizId) async {
    return await repository.getStudentAttempt(quizId);
  }
}
