import 'package:dio/dio.dart';
import '../api_endpoints.dart';
import '../api_service.dart';
import '../../../features/ai_chat/data/models/send_message_request.dart';

class AiRepository {
  final Dio _dio = apiService.dio;

  Future<String> sendMessage(SendMessageRequest request) async {
    try {
      final response = await _dio.post(ApiEndpoints.aiSendMessage, data: request.toJson());
      return response.data['reply'];
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<List<dynamic>> getSessions() async {
    try {
      final response = await _dio.get(ApiEndpoints.aiSessions);
      return response.data;
    } catch (e) {
      throw Exception('Failed to get sessions: $e');
    }
  }

  Future<List<dynamic>> getMessages(int sessionId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.aiSessionMessages}$sessionId/messages');
      return response.data;
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  Future<void> deleteSession(int sessionId) async {
    try {
      await _dio.delete('${ApiEndpoints.aiDeleteSession}$sessionId');
    } catch (e) {
      throw Exception('Failed to delete session: $e');
    }
  }
}
