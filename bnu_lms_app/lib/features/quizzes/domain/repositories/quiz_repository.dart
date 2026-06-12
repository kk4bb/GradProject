import 'package:dartz/dartz.dart';
import '../../../../shared/error/failure.dart';
import '../entities/quiz_entity.dart';
import '../entities/quiz_attempt_entity.dart';
import '../entities/quiz_take_entity.dart';

abstract class QuizRepository {
  Future<Either<Failure, List<QuizEntity>>> getQuizzes(int courseId);
  Future<Either<Failure, QuizAttemptEntity>> submitQuiz(int quizId, Map<String, dynamic> submissionData);
  Future<Either<Failure, bool>> gradeEssay(int quizId, int attemptId, double manualScore);
  Future<Either<Failure, bool>> publishGrades(int quizId);
  Future<Either<Failure, QuizEntity>> createQuiz(QuizEntity quiz);
  Future<Either<Failure, bool>> updateQuiz(int quizId, QuizEntity quiz);
  Future<Either<Failure, List<QuizAttemptEntity>>> getQuizAttempts(int quizId);
  Future<Either<Failure, QuizAttemptEntity>> getStudentAttempt(int quizId);
  Future<Either<Failure, QuizTakeEntity>> getQuizForTaking(int quizId);
}
