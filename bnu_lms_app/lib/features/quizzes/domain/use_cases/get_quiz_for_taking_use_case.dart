import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error/failure.dart';
import '../entities/quiz_take_entity.dart';
import '../repositories/quiz_repository.dart';

@injectable
class GetQuizForTakingUseCase {
  final QuizRepository repository;

  GetQuizForTakingUseCase(this.repository);

  Future<Either<Failure, QuizTakeEntity>> call(int quizId) async {
    return await repository.getQuizForTaking(quizId);
  }
}
