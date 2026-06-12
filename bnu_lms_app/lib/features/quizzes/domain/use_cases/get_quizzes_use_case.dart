import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

@lazySingleton
class GetQuizzesUseCase {
  final QuizRepository repository;

  GetQuizzesUseCase(this.repository);

  Future<Either<Failure, List<QuizEntity>>> call(int courseId) {
    return repository.getQuizzes(courseId);
  }
}
