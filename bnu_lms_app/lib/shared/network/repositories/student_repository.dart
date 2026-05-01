import 'package:dio/dio.dart';
import '../api_endpoints.dart';
import '../api_service.dart';
import '../../../../features/profile/student/data/models/student_profile_model.dart';
import '../../../../features/home/presentation/student/data/models/student_dashboard_model.dart';

class StudentRepository {
  final Dio _dio = apiService.dio;

  Future<StudentDashboard> getDashboard() async {
    try {
      final response = await _dio.get(ApiEndpoints.studentDashboard);
      return StudentDashboard.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load dashboard: $e');
    }
  }

  Future<StudentProfile> getProfile() async {
    try {
      final response = await _dio.get(ApiEndpoints.studentProfile);
      return StudentProfile.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load profile: $e');
    }
  }
}
