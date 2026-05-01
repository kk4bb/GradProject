import 'package:dio/dio.dart';
import '../api_endpoints.dart';
import '../api_service.dart';

class AIChatRepository {
  final Dio _dio = apiService.dio;

  Future<String> sendChatMessage(String message) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.aiChat,
        data: {'message': message},
      );
      return response.data['response'] ?? 'No response from AI.';
    } catch (e) {
      // Fallback to a mock response if backend is not ready
      if (e is DioException && (e.response?.statusCode == 404 || e.type == DioExceptionType.connectionError)) {
        await Future.delayed(const Duration(seconds: 2));
        return "I understand your question: '$message'. This is a mock response because the AI backend is currently being integrated. Please try again later!";
      }
      throw Exception('Failed to communicate with AI: $e');
    }
  }
}
