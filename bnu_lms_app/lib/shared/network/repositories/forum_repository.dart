import 'package:dio/dio.dart';
import '../api_endpoints.dart';
import '../api_service.dart';
import '../../../../features/forums/data/models/forum_model.dart';

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

  Future<void> createPost(int discussionId, String content) async {
    try {
      await _dio.post(
        '${ApiEndpoints.createPost}$discussionId',
        data: {'content': content},
      );
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  Future<void> createComment(int postId, String content) async {
    try {
      await _dio.post(
        '${ApiEndpoints.createComment}$postId',
        data: {'content': content},
      );
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  Future<void> createDiscussion(int courseId, String title) async {
    try {
      await _dio.post(
        '${ApiEndpoints.createDiscussion}$courseId',
        data: '"$title"', // Backend expects a plain string in body
      );
    } catch (e) {
      throw Exception('Failed to create discussion: $e');
    }
  }
}
