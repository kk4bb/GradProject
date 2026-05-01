import 'package:dio/dio.dart';
import '../api_endpoints.dart';
import '../api_service.dart';

class MarkAttendanceRequest {
  final String qrCodeToken;
  final String deviceId;
  final double? latitude;
  final double? longitude;

  MarkAttendanceRequest({
    required this.qrCodeToken,
    required this.deviceId,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'qrCodeToken': qrCodeToken,
      'deviceId': deviceId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class CreateAttendanceSessionRequest {
  final int courseId;
  final String sessionTitle;
  final int durationMinutes;
  final double? latitude;
  final double? longitude;

  CreateAttendanceSessionRequest({
    required this.courseId,
    required this.sessionTitle,
    required this.durationMinutes,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'sessionTitle': sessionTitle,
      'durationMinutes': durationMinutes,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class AttendanceSessionResponse {
  final int sessionId;
  final String sessionTitle;
  final String qrCodeToken;
  final DateTime expiresAt;

  AttendanceSessionResponse({
    required this.sessionId,
    required this.sessionTitle,
    required this.qrCodeToken,
    required this.expiresAt,
  });

  factory AttendanceSessionResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceSessionResponse(
      sessionId: json['sessionId'],
      sessionTitle: json['sessionTitle'],
      qrCodeToken: json['qrCodeToken'],
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }
}

class AttendanceRecordDto {
  final String studentId;
  final String studentName;
  final DateTime? scannedAt;
  final bool isPresent;

  AttendanceRecordDto({
    required this.studentId,
    required this.studentName,
    this.scannedAt,
    required this.isPresent,
  });

  factory AttendanceRecordDto.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordDto(
      studentId: json['studentId'],
      studentName: json['studentName'],
      scannedAt: json['scannedAt'] != null ? DateTime.parse(json['scannedAt']) : null,
      isPresent: json['isPresent'],
    );
  }
}

class CourseAttendanceReport {
  final int sessionId;
  final String sessionTitle;
  final DateTime createdAt;
  final List<AttendanceRecordDto> attendanceRecords;

  CourseAttendanceReport({
    required this.sessionId,
    required this.sessionTitle,
    required this.createdAt,
    required this.attendanceRecords,
  });

  factory CourseAttendanceReport.fromJson(Map<String, dynamic> json) {
    return CourseAttendanceReport(
      sessionId: json['sessionId'],
      sessionTitle: json['sessionTitle'],
      createdAt: DateTime.parse(json['createdAt']),
      attendanceRecords: (json['attendanceRecords'] as List)
          .map((e) => AttendanceRecordDto.fromJson(e))
          .toList(),
    );
  }
}

class AttendanceRecord {
  final DateTime date;
  final bool isPresent;

  AttendanceRecord({required this.date, required this.isPresent});

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      date: DateTime.parse(json['date']),
      isPresent: json['isPresent'] ?? false,
    );
  }
}

class AttendanceRepository {
  final Dio _dio = apiService.dio;

  // Student methods
  Future<void> markAttendance(MarkAttendanceRequest request) async {
    try {
      await _dio.post(
        ApiEndpoints.markAttendance,
        data: request.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to mark attendance: $e');
    }
  }

  Future<List<AttendanceRecord>> getMyAttendance(int courseId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.myAttendance}$courseId');
      return (response.data as List)
          .map((e) => AttendanceRecord.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load attendance records: $e');
    }
  }

  // Instructor methods
  Future<AttendanceSessionResponse> createSession(CreateAttendanceSessionRequest request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.createAttendanceSession,
        data: request.toJson(),
      );
      return AttendanceSessionResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create attendance session: $e');
    }
  }

  Future<List<CourseAttendanceReport>> getCourseAttendanceReport(int courseId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.courseAttendanceReport}$courseId');
      return (response.data as List)
          .map((e) => CourseAttendanceReport.fromJson(e))
          .toList();
    } catch (e) {
      throw Exception('Failed to load course attendance report: $e');
    }
  }
}
