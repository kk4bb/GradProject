import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance_record_entity.dart';
import '../../domain/entities/attendance_session_entity.dart';
import '../../domain/entities/course_attendance_report_entity.dart';

abstract class InstructorAttendanceState extends Equatable {
  const InstructorAttendanceState();

  @override
  List<Object?> get props => [];
}

class InstructorAttendanceInitial extends InstructorAttendanceState {
  const InstructorAttendanceInitial();
}

class InstructorAttendanceLoading extends InstructorAttendanceState {
  const InstructorAttendanceLoading();
}

class InstructorSessionCreated extends InstructorAttendanceState {
  final AttendanceSessionEntity session;

  const InstructorSessionCreated(this.session);

  @override
  List<Object?> get props => [session];
}

class InstructorAttendeesLoaded extends InstructorAttendanceState {
  final List<AttendanceRecordEntity> attendees;

  const InstructorAttendeesLoaded(this.attendees);

  @override
  List<Object?> get props => [attendees];
}

class InstructorAttendanceError extends InstructorAttendanceState {
  final String message;

  const InstructorAttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}

class InstructorHistoryLoaded extends InstructorAttendanceState {
  final List<CourseAttendanceReportEntity> reports;

  const InstructorHistoryLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}
