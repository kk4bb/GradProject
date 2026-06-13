import 'package:equatable/equatable.dart';
import '../../domain/entities/course_attendance_report_entity.dart';

abstract class StudentAttendanceState extends Equatable {
  const StudentAttendanceState();

  @override
  List<Object?> get props => [];
}

class StudentAttendanceInitial extends StudentAttendanceState {
  const StudentAttendanceInitial();
}

class StudentAttendanceLoading extends StudentAttendanceState {
  final String statusMessage;

  const StudentAttendanceLoading({this.statusMessage = "Verifying Location & Device..."});

  @override
  List<Object?> get props => [statusMessage];
}

class StudentAttendanceSuccess extends StudentAttendanceState {
  const StudentAttendanceSuccess();
}

class StudentAttendanceError extends StudentAttendanceState {
  final String message;

  const StudentAttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Dashboard states ──────────────────────────────────────────────────────────

class StudentDashboardLoading extends StudentAttendanceState {
  const StudentDashboardLoading();
}

class StudentDashboardLoaded extends StudentAttendanceState {
  final List<CourseAttendanceReportEntity> reports;
  final int presentCount;
  final int absentCount;
  final double attendanceRate;

  const StudentDashboardLoaded({
    required this.reports,
    required this.presentCount,
    required this.absentCount,
    required this.attendanceRate,
  });

  @override
  List<Object?> get props => [reports, presentCount, absentCount, attendanceRate];
}

class StudentDashboardError extends StudentAttendanceState {
  final String message;

  const StudentDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

