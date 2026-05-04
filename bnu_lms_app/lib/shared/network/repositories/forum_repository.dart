import 'package:dio/dio.dart';
import '../api_endpoints.dart';
import '../../../../features/forums/data/models/forum_model.dart';
import '../api_service.dart';

class ForumRepository {
  final Dio _dio = apiService.dio;

  Future<List<Discussion>> getDiscussions(int courseId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.courseDiscussions}$courseId');
      return (response.data as List)
          .map((e) => Discussion.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load discussions: $e');
    }
  }

  Future<List<Post>> getPosts(int discussionId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.discussionPosts}$discussionId');
      return (response.data as List)
          .map((e) => Post.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  Future<int> createDiscussion(int courseId, String title) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.createDiscussion}$courseId/discussion',
        data: '"$title"', // Backend expects a plain string as JSON body
        options: Options(contentType: 'application/json'),
      );
      return response.data['id'];
    } catch (e) {
      throw Exception('Failed to create discussion: $e');
    }
  }

  Future<int> createPost(int discussionId, String content) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.createPost}$discussionId/post',
        data: {'content': content},
      );
      return response.data['id'];
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }
}
