import 'package:dio/dio.dart';
import '../api_endpoints.dart';
import '../api_service.dart';
import '../../../../features/tasks/data/models/assignment_model.dart';

class AssignmentRepository {
  final Dio _dio = apiService.dio;

  Future<List<Assignment>> getAssignments(int courseId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.courseAssignments}$courseId');
      return (response.data as List)
          .map((e) => Assignment.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load assignments: $e');
    }
  }

  Future<void> submitAssignment(int assignmentId, String fileUrl) async {
    try {
      await _dio.post(
        '${ApiEndpoints.submitAssignment}$assignmentId/submit',
        data: {'fileUrl': fileUrl},
      );
    } catch (e) {
      throw Exception('Failed to submit assignment: $e');
    }
  }
}
