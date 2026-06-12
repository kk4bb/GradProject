import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../shared/config/api_constants.dart';
import '../../../../../shared/error/remote_exception.dart';
import '../../models/attendance_record_model.dart';
import '../../models/attendance_session_model.dart';
import '../../models/course_attendance_report_model.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceSessionModel> createSession({
    required int courseId,
    required String title,
    required int duration,
    required double lat,
    required double lng,
  });

  Future<bool> markAttendance({
    required String token,
    required String deviceId,
    required double lat,
    required double lng,
  });

  Future<List<AttendanceRecordModel>> getAttendedStudents(int courseId);

  Future<bool> removeAttendanceRecord({
    required int courseId,
    required String studentId,
  });

  Future<List<CourseAttendanceReportModel>> getCourseAttendanceReports(int courseId);

  /// Student-specific: GET /api/Attendance/my/{courseId}
  Future<List<AttendanceRecordModel>> getMyAttendanceHistory(int courseId);
}

@LazySingleton(as: AttendanceRemoteDataSource)
class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final Dio _dio;

  const AttendanceRemoteDataSourceImpl(this._dio);

  @override
  Future<AttendanceSessionModel> createSession({
    required int courseId,
    required String title,
    required int duration,
    required double lat,
    required double lng,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}Attendance/session',
        data: {
          'courseId': courseId,
          'sessionTitle': title,
          'durationMinutes': duration,
          'latitude': lat,
          'longitude': lng,
        },
      );
      return AttendanceSessionModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw RemoteException(message: _extractErrorMessage(e));
    }
  }

  @override
  Future<bool> markAttendance({
    required String token,
    required String deviceId,
    required double lat,
    required double lng,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}Attendance/mark',
        data: {
          'qrCodeToken': token,
          'deviceId': deviceId,
          'latitude': lat,
          'longitude': lng,
        },
      );
      final data = response.data;
      if (data is String) {
        return true;
      }
      return true;
    } on DioException catch (e) {
      throw RemoteException(message: _extractErrorMessage(e));
    }
  }

  @override
  Future<List<AttendanceRecordModel>> getAttendedStudents(int courseId) async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}Attendance/course/$courseId');
      final reports = response.data as List<dynamic>;
      if (reports.isEmpty) return [];

      // Get the latest session report (first item as sorted DESC by CreatedAt in backend)
      final latestSession = reports.first as Map<String, dynamic>;
      final recordsList = latestSession['attendanceRecords'] as List<dynamic>? ?? [];

      // Only return students who are present
      return recordsList
          .map((e) => AttendanceRecordModel.fromJson(e as Map<String, dynamic>))
          .where((record) => record.isPresent)
          .toList();
    } on DioException catch (e) {
      throw RemoteException(message: _extractErrorMessage(e));
    }
  }

  @override
  Future<bool> removeAttendanceRecord({
    required int courseId,
    required String studentId,
  }) async {
    try {
      await _dio.delete(
        '${ApiConstants.baseUrl}Attendance/record',
        data: {
          'courseId': courseId,
          'studentId': studentId,
        },
      );
      return true;
    } on DioException catch (e) {
      throw RemoteException(message: _extractErrorMessage(e));
    }
  }

  @override
  Future<List<CourseAttendanceReportModel>> getCourseAttendanceReports(int courseId) async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}Attendance/course/$courseId');
      final reports = response.data as List<dynamic>;
      return reports
          .map((e) => CourseAttendanceReportModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw RemoteException(message: _extractErrorMessage(e));
    }
  }

  @override
  Future<List<AttendanceRecordModel>> getMyAttendanceHistory(int courseId) async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}Attendance/my/$courseId');
      final list = response.data as List<dynamic>? ?? [];
      return list
          .map((e) => AttendanceRecordModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return [];
      throw RemoteException(message: _extractErrorMessage(e));
    }
  }

  String _extractErrorMessage(DioException e) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 403) return 'You do not have permission to perform this action.';
    if (statusCode == 404) return 'Error 404: Resource or session not found. Please verify the course exists.';

    String? message;
    final data = e.response?.data;
    if (data is Map) {
      message = data['message'] as String? ??
          data['Message'] as String? ??
          data.toString();
    } else if (data is String) {
      message = data;
    } else {
      message = data?.toString();
    }

    if (message == null || message.trim().isEmpty) {
      return 'Attendance failed ($statusCode): Ensure the QR code is valid and you are within the allowed range.';
    }
    return message;
  }
}
