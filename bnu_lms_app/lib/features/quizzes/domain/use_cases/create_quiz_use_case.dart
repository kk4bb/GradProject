import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error/failure.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

@injectable
class CreateQuizUseCase {
  final QuizRepository repository;

  CreateQuizUseCase(this.repository);

  Future<Either<Failure, QuizEntity>> call(QuizEntity quiz) async {
    return await repository.createQuiz(quiz);
  }
}
