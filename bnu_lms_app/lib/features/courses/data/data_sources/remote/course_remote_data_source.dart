// lib/features/courses/data/data_sources/remote/course_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../shared/config/api_constants.dart';
import '../../../../../shared/error/remote_exception.dart';
import '../../models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseSummaryModel>> getEnrolledCourses();
  Future<List<CourseSummaryModel>> getAssignedCourses();
  Future<CourseDetailModel> getCourseDetails(int id);
  Future<int> createModule(int courseId, String title);
  Future<int> addLesson(int moduleId, String title);
  Future<int> addContent(int lessonId, String type, String url);
  Future<int> uploadContent(int lessonId, String contentType, String filePath, String fileName);
  Future<void> deleteContent(int contentId);
}

@LazySingleton(as: CourseRemoteDataSource)
class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final Dio _dio;

  const CourseRemoteDataSourceImpl(this._dio);

  @override
  Future<List<CourseSummaryModel>> getEnrolledCourses() async {
    try {
      final response = await _dio.get('${ApiConstants.courses}/enrolled');
      final data = response.data as List<dynamic>;
      return data.map((e) => CourseSummaryModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw RemoteException(message: _extractErrorMessage(e));
    }
  }

  @override
  Future<List<CourseSummaryModel>> getAssignedCourses() async {
    try {
      final response = await _dio.get('${ApiConstants.courses}/assigned');
      final data = response.data as List<dynamic>;
      return data.map((e) => CourseSummaryModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw RemoteException(message: _extractErrorMessage(e));
    }
  }

  @override
  Future<CourseDetailModel> getCourseDetails(int id) async {
    try {
      final response = await _dio.get('${ApiConstants.courses}/$id');
      print('DEBUG: Course Details JSON: ${response.data}'); // DEBUG
      return CourseDetailModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw RemoteException(message: _extractErrorMessage(e));
    }
  }

  @override
  Future<int> createModule(int courseId, String title) async {
    try {
      // Body is a raw string as per backend: [FromBody] string title
      final response = await _dio.post(
        '${ApiConstants.courses}/$courseId/module',
        data: '"$title"', 
      );
      return response.data['id'] as int;
    } on DioException catch (e) {
      throw RemoteException(message: _extractErrorMessage(e));
    }
  }

  @override
  Future<int> addLesson(int moduleId, String title) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.courses}/module/$moduleId/lesson',
        data: '"$title"',
      );
      return response.data['id'] as int;
    } on DioException catch (e) {
      throw RemoteException(message: _extractErrorMessage(e));
    }
  }

  @override
  Future<int> addContent(int lessonId, String type, String url) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.courses}/lesson/$lessonId/content',
        queryParameters: {'type': type},
        data: '"$url"',
      );
      return response.data['id'] as int;
    } on DioException catch (e) {
      throw RemoteException(message: _extractErrorMessage(e));
    }
  }

  @override
  Future<int> uploadContent(int lessonId, String contentType, String filePath, String fileName) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'contentType': contentType,
      });

      final response = await _dio.post(
        '${ApiConstants.courses}/lesson/$lessonId/content',
        data: formData,
      );
      
      // The backend returns { ContentId = contentId, Url = fileUrl }
      return (response.data['contentId'] ?? response.data['ContentId']) as int;
    } on DioException catch (e) {
      throw RemoteException(message: _extractErrorMessage(e));
    }
  }

  @override
  Future<void> deleteContent(int contentId) async {
    try {
      await _dio.delete('${ApiConstants.courses}/content/$contentId');
    } on DioException catch (e) {
      throw RemoteException(message: _extractErrorMessage(e));
    }
  }

  String _extractErrorMessage(DioException e) {
    if (e.response?.statusCode == 403) {
      return 'You do not have permission to perform this action.';
    }
    return e.response?.data?['message'] as String? ??
        e.response?.data?.toString() ??
        'An error occurred. Please try again.';
  }
}
