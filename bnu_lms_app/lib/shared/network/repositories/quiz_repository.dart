import 'package:dio/dio.dart';
import '../api_endpoints.dart';
import '../api_service.dart';
import '../../../../features/quizzes/data/models/quiz_model.dart';

class QuizRepository {
  final Dio _dio = apiService.dio;

  Future<List<Quiz>> getQuizzes(int courseId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.courseQuizzes}$courseId');
      return (response.data as List)
          .map((e) => Quiz.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load quizzes: $e');
    }
  }

  Future<QuizTake> takeQuiz(int quizId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.takeQuiz}$quizId');
      return QuizTake.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to start quiz: $e');
    }
  }

  Future<QuizResult> submitQuiz(int quizId, List<Map<String, int>> answers) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.submitQuiz}$quizId',
        data: {'answers': answers},
      );
      return QuizResult.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to submit quiz: $e');
    }
  }
}
