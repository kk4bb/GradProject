import 'package:dio/dio.dart';
import '../../../../shared/config/api_constants.dart';
import '../../../../shared/error/remote_exception.dart';
import '../../domain/entities/forum_entities.dart';

abstract class ForumsRemoteDataSource {
  Future<List<DiscussionEntity>> getDiscussions(int courseId);
  Future<List<PostEntity>> getPosts(int discussionId);
  Future<void> createPost(int discussionId, String content);
  Future<void> createComment(int postId, String content);
  Future<int> createDiscussion(int courseId, String title, [String content = '']);
  Future<void> markPostAsCorrect(int postId);
  Future<void> votePost(int postId, bool isUpvote);
  Future<void> updateDiscussionStatus(int discussionId, String status);
}

class ForumsRemoteDataSourceImpl implements ForumsRemoteDataSource {
  final Dio _dio;

  const ForumsRemoteDataSourceImpl(this._dio);

  @override
  Future<List<DiscussionEntity>> getDiscussions(int courseId) async {
    try {
      final res = await _dio.get('${ApiConstants.baseUrl}Forum/course/$courseId');
      final list = res.data as List<dynamic>;
      return list.map((e) {
        final m = e as Map<String, dynamic>;
        return DiscussionEntity(
          id: m['id'] as int,
          title: m['title'] as String? ?? '',
          postCount: m['postCount'] as int? ?? 0,
          status: m['status'] as String? ?? 'OPEN',
          createdAt: _parseDate(m['createdAt']),
          authorName: m['authorName'] as String?,
          authorAvatarUrl: m['authorAvatarUrl'] as String?,
          content: m['content'] as String?,
        );
      }).toList();
    } on DioException catch (e) {
      final msg = _msg(e).toLowerCase();
      if (e.response?.statusCode == 404 || msg.contains('not found')) return [];
      throw RemoteException(message: _msg(e));
    }
  }

  @override
  Future<List<PostEntity>> getPosts(int discussionId) async {
    try {
      final res = await _dio.get('${ApiConstants.baseUrl}Forum/discussion/$discussionId');
      final list = res.data as List<dynamic>;
      return list.map((e) {
        final m = e as Map<String, dynamic>;
        final rawComments = m['comments'] as List<dynamic>? ?? [];
        return PostEntity(
          id: m['id'] as int,
          authorName: m['authorName'] as String? ?? 'Unknown',
          authorAvatarUrl: m['authorAvatarUrl'] as String?,
          content: m['content'] as String? ?? '',
          commentCount: m['commentCount'] as int? ?? 0,
          isCorrect: m['isCorrect'] as bool? ?? false,
          votes: m['votes'] as int? ?? 0,
          approvedByRole: m['approvedByRole'] as String?,
          createdAt: _parseDate(m['createdAt']),
          comments: rawComments.map((c) {
            final cm = c as Map<String, dynamic>;
            return CommentEntity(
              id: cm['id'] as int,
              authorName: cm['authorName'] as String? ?? 'Unknown',
              authorAvatarUrl: cm['authorAvatarUrl'] as String?,
              content: cm['content'] as String? ?? '',
            );
          }).toList(),
        );
      }).toList();
    } on DioException catch (e) {
      throw RemoteException(message: _msg(e));
    }
  }

  @override
  Future<void> createPost(int discussionId, String content) async {
    try {
      await _dio.post(
        '${ApiConstants.baseUrl}Forum/discussion/$discussionId/post',
        data: {'content': content},
      );
    } on DioException catch (e) {
      throw RemoteException(message: _msg(e));
    }
  }

  @override
  Future<void> createComment(int postId, String content) async {
    try {
      await _dio.post(
        '${ApiConstants.baseUrl}Forum/post/$postId/comment',
        data: {'content': content},
      );
    } on DioException catch (e) {
      throw RemoteException(message: _msg(e));
    }
  }

  @override
  Future<int> createDiscussion(int courseId, String title, [String content = '']) async {
    if (courseId <= 0) throw Exception('CRITICAL: courseId is invalid ($courseId)');
    try {
      final res = await _dio.post(
        '${ApiConstants.baseUrl}Forum/course/$courseId/discussion',
        data: {
          'title': title,
          'content': content,
        },
      );
      final dynamic data = res.data;
      return (data['id'] ?? data['Id']) as int;
    } on DioException catch (e) {
      throw RemoteException(message: _msg(e));
    }
  }

  @override
  Future<void> markPostAsCorrect(int postId) async {
    try {
      await _dio.post('${ApiConstants.baseUrl}Forum/post/$postId/correct');
    } on DioException catch (e) {
      throw RemoteException(message: _msg(e));
    }
  }

  @override
  Future<void> votePost(int postId, bool isUpvote) async {
    try {
      await _dio.post(
        '${ApiConstants.baseUrl}Forum/post/$postId/vote',
        data: isUpvote,
        options: Options(contentType: Headers.jsonContentType),
      );
    } on DioException catch (e) {
      throw RemoteException(message: _msg(e));
    }
  }

  @override
  Future<void> updateDiscussionStatus(int discussionId, String status) async {
    try {
      await _dio.put(
        '${ApiConstants.baseUrl}Forum/discussion/$discussionId/status',
        data: '"$status"',
        options: Options(contentType: Headers.jsonContentType),
      );
    } on DioException catch (e) {
      throw RemoteException(message: _msg(e));
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  DateTime? _parseDate(dynamic raw) {
    if (raw == null) return null;
    try {
      final date = raw as String;
      return DateTime.parse(date.endsWith('Z') ? date : '${date}Z').toLocal();
    } catch (_) { return null; }
  }

  String _msg(DioException e) {
    if (e.response?.statusCode == 403) return 'You are not authorized to perform this action.';
    if (e.response?.statusCode == 404) return 'Forum or discussion not found.';
    final data = e.response?.data;
    if (data is Map) return (data['message'] ?? data['Message'] ?? data.toString()) as String;
    if (data is String && data.isNotEmpty) return data;
    return 'An unexpected error occurred (${e.response?.statusCode}).';
  }
}
