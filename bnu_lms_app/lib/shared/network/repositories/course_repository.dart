import 'package:dio/dio.dart';
import '../api_endpoints.dart';
import '../api_service.dart';
import '../../../../features/courses/data/models/course_model.dart';
import '../../../../features/profile/student/data/models/student_profile_model.dart';

class CourseRepository {
  final Dio _dio = apiService.dio;

  Future<List<CourseSummary>> getEnrolledCourses() async {
    try {
      final response = await _dio.get(ApiEndpoints.enrolledCourses);
      return (response.data as List)
          .map((e) => CourseSummary.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load enrolled courses: $e');
    }
  }

  Future<List<CourseSummary>> getAssignedCourses() async {
    try {
      final response = await _dio.get(ApiEndpoints.assignedCourses);
      return (response.data as List)
          .map((e) => CourseSummary.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load assigned courses: $e');
    }
  }

  Future<List<StudentProfile>> getEnrolledStudents(int courseId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.courseDetails}$courseId/students');
      return (response.data as List)
          .map((e) => StudentProfile.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load enrolled students: $e');
    }
  }

  Future<CourseDetail> getCourseDetails(int id) async {
    try {
      final response = await _dio.get('${ApiEndpoints.courseDetails}$id');
      return CourseDetail.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load course details: $e');
    }
  }

  Future<int> createModule(int courseId, String title) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.courseDetails}$courseId/module',
        data: '"$title"', // Sending as JSON string
        options: Options(contentType: 'application/json'),
      );
      return response.data['id'];
    } catch (e) {
      throw Exception('Failed to create module: $e');
    }
  }

  Future<int> addLesson(int moduleId, String title) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.addLesson}$moduleId/lesson',
        data: '"$title"',
        options: Options(contentType: 'application/json'),
      );
      return response.data['id'];
    } catch (e) {
      throw Exception('Failed to add lesson: $e');
    }
  }

  Future<int> addContent(int lessonId, String type, String url) async {
    try {
      final response = await _dio.post(
        '${ApiEndpoints.addContent}$lessonId/content',
        queryParameters: {'type': type},
        data: '"$url"',
        options: Options(contentType: 'application/json'),
      );
      return response.data['id'];
    } catch (e) {
      throw Exception('Failed to add content: $e');
    }
  }
}
