import 'package:dartz/dartz.dart';
import '../../../../shared/error/failure.dart';
import '../../domain/entities/attendance_record_entity.dart';
import '../../domain/entities/attendance_session_entity.dart';
import '../../domain/entities/course_attendance_report_entity.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, AttendanceSessionEntity>> createSession({
    required int courseId,
    required String title,
    required int duration,
    required double lat,
    required double lng,
  });

  Future<Either<Failure, bool>> markAttendance({
    required String token,
    required String deviceId,
    required double lat,
    required double lng,
  });

  Future<Either<Failure, List<AttendanceRecordEntity>>> getAttendedStudents(int courseId);

  Future<Either<Failure, bool>> removeAttendanceRecord({
    required int courseId,
    required String studentId,
  });

  Future<Either<Failure, List<CourseAttendanceReportEntity>>> getCourseAttendanceReports(int courseId);

  /// Student-specific: fetches the authenticated student's own attendance records
  /// across all sessions for a course. Hits GET /api/Attendance/my/{courseId}.
  Future<Either<Failure, List<AttendanceRecordEntity>>> getMyAttendanceHistory(int courseId);
}
