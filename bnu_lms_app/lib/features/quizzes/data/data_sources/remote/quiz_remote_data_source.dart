import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/quiz_entity.dart';
import '../../models/quiz_attempt_model.dart';
import '../../models/quiz_model.dart';
import '../../models/quiz_take_model.dart';

class ServerException implements Exception {
  final String message;
  const ServerException({required this.message});
}

abstract class QuizRemoteDataSource {
  Future<List<QuizModel>> getQuizzes(int courseId);
  Future<QuizAttemptModel> submitQuiz(int quizId, Map<String, dynamic> submissionData);
  Future<bool> gradeEssay(int quizId, int attemptId, double manualScore);
  Future<bool> publishGrades(int quizId);
  Future<QuizModel> createQuiz(QuizEntity quiz);
  Future<bool> updateQuiz(int quizId, QuizEntity quiz);
  Future<List<QuizAttemptModel>> getQuizAttempts(int quizId);
  Future<QuizAttemptModel> getStudentAttempt(int quizId);
  Future<QuizTakeModel> getQuizForTaking(int quizId);
}

@LazySingleton(as: QuizRemoteDataSource)
class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final Dio dio;

  QuizRemoteDataSourceImpl(this.dio);

  @override
  Future<List<QuizModel>> getQuizzes(int courseId) async {
    try {
      final response = await dio.get('quiz/course/$courseId');
      return (response.data as List).map((x) => QuizModel.fromJson(x)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.response?.statusMessage ?? "Error");
    }
  }

  @override
  Future<QuizAttemptModel> submitQuiz(int quizId, Map<String, dynamic> submissionData) async {
    try {
      final response = await dio.post('quiz/$quizId/submit', data: submissionData);
      return QuizAttemptModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.statusMessage ?? "Error");
    }
  }

  @override
  Future<bool> gradeEssay(int quizId, int attemptId, double manualScore) async {
    try {
      final response = await dio.put('quiz/$quizId/attempts/$attemptId/grade', data: manualScore);
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.statusMessage ?? "Error");
    }
  }

  @override
  Future<bool> publishGrades(int quizId) async {
    try {
      final response = await dio.put('quiz/$quizId/publish-grades');
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.statusMessage ?? "Error");
    }
  }

  @override
  Future<QuizModel> createQuiz(QuizEntity quiz) async {
    try {
      final data = {
        "title": quiz.title,
        "description": quiz.description,
        "courseId": quiz.courseId,
        "startDate": quiz.startDate.toIso8601String(),
        "endDate": quiz.endDate.toIso8601String(),
        "durationMinutes": quiz.durationMinutes,
        "isAutoGraded": quiz.isAutoGraded,
        "allowMultipleAttempts": quiz.attemptsAllowed > 1,
        if (quiz.creationQuestions != null)
          "questions": quiz.creationQuestions!.map((q) => {
            "text": q['text'],
            "imageUrl": null,
            "isEssay": q['isEssay'] ?? false,
            "points": q['points'] ?? 1,
            "options": q['options'] != null ? (q['options'] as List).map((o) => {
              "text": o['text'],
              "isCorrect": o['isCorrect'],
            }).toList() : [],
          }).toList(),
      };
      
      final response = await dio.post('quiz', data: data);
      return QuizModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.statusMessage ?? "Error");
    }
  }

  @override
  Future<bool> updateQuiz(int quizId, QuizEntity quiz) async {
    try {
      final data = {
        "title": quiz.title,
        "description": quiz.description,
        "startDate": quiz.startDate.toIso8601String(),
        "endDate": quiz.endDate.toIso8601String(),
        "durationMinutes": quiz.durationMinutes,
        "isAutoGraded": quiz.isAutoGraded,
      };
      final response = await dio.put('quiz/$quizId', data: data);
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw ServerException(message: e.response?.statusMessage ?? "Error");
    }
  }

  @override
  Future<List<QuizAttemptModel>> getQuizAttempts(int quizId) async {
    try {
      final response = await dio.get('quiz/$quizId/attempts');
      return (response.data as List).map((x) => QuizAttemptModel.fromJson(x)).toList();
    } on DioException catch (e) {
      throw ServerException(message: e.response?.statusMessage ?? "Error");
    }
  }

  @override
  Future<QuizTakeModel> getQuizForTaking(int quizId) async {
    try {
      final response = await dio.get('quiz/$quizId/take');
      return QuizTakeModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.response?.statusMessage ?? "Error");
    }
  }

  @override
  Future<QuizAttemptModel> getStudentAttempt(int quizId) async {
    try {
      final response = await dio.get('quiz/$quizId/my-attempt');
      return QuizAttemptModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw ServerException(message: "Grades are not published yet.");
      }
      if (e.response?.statusCode == 400 || e.response?.statusCode == 404) {
        throw ServerException(message: "No attempt found.");
      }
      throw ServerException(message: e.response?.statusMessage ?? "Error");
    }
  }
}
