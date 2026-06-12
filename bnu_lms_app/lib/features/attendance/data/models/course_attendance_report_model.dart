import '../../domain/entities/course_attendance_report_entity.dart';
import 'attendance_record_model.dart';

class CourseAttendanceReportModel extends CourseAttendanceReportEntity {
  const CourseAttendanceReportModel({
    required super.sessionId,
    required super.sessionTitle,
    required super.createdAt,
    required super.attendanceRecords,
  });

  factory CourseAttendanceReportModel.fromJson(Map<String, dynamic> json) {
    final recordsList = json['attendanceRecords'] as List<dynamic>? ?? [];
    return CourseAttendanceReportModel(
      sessionId: json['sessionId'] as int,
      sessionTitle: json['sessionTitle'] as String? ?? 'Lecture',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      attendanceRecords: recordsList
          .map((e) => AttendanceRecordModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'sessionTitle': sessionTitle,
      'createdAt': createdAt.toIso8601String(),
      'attendanceRecords': attendanceRecords
          .map((e) => (e as AttendanceRecordModel).toJson())
          .toList(),
    };
  }
}
