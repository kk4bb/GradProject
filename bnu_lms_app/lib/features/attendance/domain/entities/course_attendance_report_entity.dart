import '../../domain/entities/attendance_record_entity.dart';

class CourseAttendanceReportEntity {
  final int sessionId;
  final String sessionTitle;
  final DateTime createdAt;
  final List<AttendanceRecordEntity> attendanceRecords;

  const CourseAttendanceReportEntity({
    required this.sessionId,
    required this.sessionTitle,
    required this.createdAt,
    required this.attendanceRecords,
  });
}
