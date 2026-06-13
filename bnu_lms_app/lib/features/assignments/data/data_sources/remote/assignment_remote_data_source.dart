import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:bnu_lms_app/shared/config/api_constants.dart';

import '../../models/assignment_model.dart';
import '../../models/submission_model.dart';


abstract class AssignmentRemoteDataSource {
  Future<List<AssignmentModel>> getAssignmentsByCourse(int courseId);
  Future<AssignmentModel> getAssignmentDetail(int assignmentId);
  Future<int> createAssignment(int courseId, Map<String, dynamic> assignmentData);
  Future<void> submitAssignment(int assignmentId, Map<String, dynamic> submissionData);
  Future<List<SubmissionModel>> getSubmissions(int assignmentId);
  Future<void> gradeSubmission(int submissionId, double grade, String feedback);
}

@LazySingleton(as: AssignmentRemoteDataSource)
class AssignmentRemoteDataSourceImpl implements AssignmentRemoteDataSource {
  final Dio dio;

  AssignmentRemoteDataSourceImpl(this.dio);

  @override
  Future<List<AssignmentModel>> getAssignmentsByCourse(int courseId) async {
    final response = await dio.get(ApiConstants.assignmentCourseList(courseId));
    return (response.data as List).map((json) => AssignmentModel.fromJson(json)).toList();
  }

  @override
  Future<AssignmentModel> getAssignmentDetail(int assignmentId) async {
    final response = await dio.get(ApiConstants.assignmentDetail(assignmentId));
    return AssignmentModel.fromJson(response.data);
  }

  @override
  Future<int> createAssignment(int courseId, Map<String, dynamic> assignmentData) async {
    // filePath is local-only — strip it before building the server payload
    final String? filePath = assignmentData['filePath'] as String?;
    final Map<String, dynamic> serverFields = Map.from(assignmentData)..remove('filePath');
    serverFields['courseId'] = courseId;

    final formData = FormData.fromMap(serverFields);

    // Only attach file as MultipartFile if a real path was selected
    if (filePath != null && filePath.isNotEmpty) {
      formData.files.add(MapEntry(
        'file',
        await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
      ));
    }

    try {
      final response = await dio.post(
        ApiConstants.assignmentCreate,
        data: formData,
      );
      return _parseCreatedAssignmentId(response.data);
    } on DioException catch (e) {
      rethrow;
    }
  }

  /// API returns `{ "id": n }` (camelCase JSON); tolerate plain int for older builds.
  int _parseCreatedAssignmentId(dynamic data) {
    if (data is int) return data;
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final v = map['id'] ?? map['Id'];
      if (v is int) return v;
      if (v is num) return v.toInt();
    }
    throw FormatException('Unexpected create assignment response: $data');
  }

  @override
  Future<void> submitAssignment(int assignmentId, Map<String, dynamic> submissionData) async {
    // filePath is local-only — strip it before building the server payload
    final String? filePath = submissionData['filePath'] as String?;
    final Map<String, dynamic> serverFields = Map.from(submissionData)..remove('filePath');

    final formData = FormData.fromMap(serverFields);

    // Only attach file as MultipartFile if a real path was selected
    if (filePath != null && filePath.isNotEmpty) {
      formData.files.add(MapEntry(
        'file',
        await MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
      ));
    }

    try {
      await dio.post(
        ApiConstants.assignmentSubmit(assignmentId),
        data: formData,
      );
    } on DioException catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<SubmissionModel>> getSubmissions(int assignmentId) async {
    final response = await dio.get(ApiConstants.assignmentSubmissions(assignmentId));
    return (response.data as List).map((json) => SubmissionModel.fromJson(json)).toList();
  }

  @override
  Future<void> gradeSubmission(int submissionId, double grade, String feedback) async {
    await dio.patch(
      ApiConstants.submissionGrade(submissionId),
      data: <String, dynamic>{
        'grade': grade,
        'feedback': feedback,
      },
    );
  }
}
