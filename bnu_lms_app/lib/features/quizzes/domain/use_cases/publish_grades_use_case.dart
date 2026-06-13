import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../repositories/quiz_repository.dart';

@lazySingleton
class PublishGradesUseCase {
  final QuizRepository repository;

  PublishGradesUseCase(this.repository);

  Future<Either<Failure, bool>> call(int quizId) {
    return repository.publishGrades(quizId);
  }
}
