import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error/failure.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

@injectable
class UpdateQuizUseCase {
  final QuizRepository repository;

  UpdateQuizUseCase(this.repository);

  Future<Either<Failure, bool>> call(int quizId, QuizEntity quiz) async {
    return await repository.updateQuiz(quizId, quiz);
  }
}
