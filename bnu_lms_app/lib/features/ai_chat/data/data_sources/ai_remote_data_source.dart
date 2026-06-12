import 'package:dio/dio.dart';
import 'package:bnu_lms_app/shared/config/api_constants.dart';
import '../models/ai_models.dart';

abstract class AIRemoteDataSource {
  Future<List<ChatSessionModel>> getSessions();
  Future<List<ChatMessageModel>> getMessages(int sessionId);
  Future<String> sendMessage(int? sessionId, String content, {String? base64Image});
  Future<void> deleteSession(int sessionId);
}

class AIRemoteDataSourceImpl implements AIRemoteDataSource {
  final Dio _dio;

  AIRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ChatSessionModel>> getSessions() async {
    final response = await _dio.get(ApiConstants.aiSessions);
    return (response.data as List)
        .map((json) => ChatSessionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ChatMessageModel>> getMessages(int sessionId) async {
    final response = await _dio.get(ApiConstants.aiSessionMessages(sessionId));
    return (response.data as List)
        .map((json) => ChatMessageModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<String> sendMessage(int? sessionId, String content, {String? base64Image}) async {
    final response = await _dio.post(
      ApiConstants.aiMessage,
      data: <String, dynamic>{
        'sessionId': sessionId,
        'content': content,
        if (base64Image != null) 'base64Image': base64Image,
      },
    );
    // Backend returns { "reply": "..." }
    final data = response.data;
    if (data is Map) {
      return (data['reply'] ?? data['Reply'] ?? '').toString();
    }
    return data.toString();
  }

  @override
  Future<void> deleteSession(int sessionId) async {
    await _dio.delete(ApiConstants.aiDeleteSession(sessionId));
  }
}
