import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/entities/quiz_attempt_entity.dart';
import '../../domain/entities/quiz_take_entity.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../data_sources/remote/quiz_remote_data_source.dart';
import '../mappers/quiz_mappers.dart';
import '../data_sources/remote/quiz_remote_data_source.dart' show ServerException;

@LazySingleton(as: QuizRepository)
class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource remoteDataSource;

  QuizRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<QuizEntity>>> getQuizzes(int courseId) async {
    try {
      final models = await remoteDataSource.getQuizzes(courseId);
      final entities = models.map((m) => QuizMappers.toQuizEntity(m)).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuizAttemptEntity>> submitQuiz(int quizId, Map<String, dynamic> submissionData) async {
    try {
      final model = await remoteDataSource.submitQuiz(quizId, submissionData);
      return Right(QuizMappers.toQuizAttemptEntity(model));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> gradeEssay(int quizId, int attemptId, double manualScore) async {
    try {
      final result = await remoteDataSource.gradeEssay(quizId, attemptId, manualScore);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> publishGrades(int quizId) async {
    try {
      final result = await remoteDataSource.publishGrades(quizId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuizEntity>> createQuiz(QuizEntity quiz) async {
    try {
      final result = await remoteDataSource.createQuiz(quiz);
      return Right(QuizMappers.toQuizEntity(result));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateQuiz(int quizId, QuizEntity quiz) async {
    try {
      final result = await remoteDataSource.updateQuiz(quizId, quiz);
      return Right(result);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<QuizAttemptEntity>>> getQuizAttempts(int quizId) async {
    try {
      final models = await remoteDataSource.getQuizAttempts(quizId);
      final entities = models.map((m) => QuizMappers.toQuizAttemptEntity(m)).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuizTakeEntity>> getQuizForTaking(int quizId) async {
    try {
      final model = await remoteDataSource.getQuizForTaking(quizId);
      final entity = QuizMappers.toQuizTakeEntity(model);
      return Right(entity);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuizAttemptEntity>> getStudentAttempt(int quizId) async {
    try {
      final model = await remoteDataSource.getStudentAttempt(quizId);
      final entity = QuizMappers.toQuizAttemptEntity(model);
      return Right(entity);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
