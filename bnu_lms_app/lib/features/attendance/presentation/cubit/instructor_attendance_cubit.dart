import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/attendance_repository.dart';
import 'instructor_attendance_state.dart';

@injectable
class InstructorAttendanceCubit extends Cubit<InstructorAttendanceState> {
  final AttendanceRepository _repository;

  InstructorAttendanceCubit(this._repository) : super(const InstructorAttendanceInitial());

  Future<void> createSession({
    required int courseId,
    required String title,
    required int duration,
    required double lat,
    required double lng,
  }) async {
    emit(const InstructorAttendanceLoading());
    final result = await _repository.createSession(
      courseId: courseId,
      title: title,
      duration: duration,
      lat: lat,
      lng: lng,
    );
    result.fold(
      (failure) => emit(InstructorAttendanceError(failure.message)),
      (session) => emit(InstructorSessionCreated(session)),
    );
  }

  Future<void> fetchActiveAttendees(int courseId) async {
    // If not already loading, show standard loading or keep existing state
    final result = await _repository.getAttendedStudents(courseId);
    result.fold(
      (failure) => emit(InstructorAttendanceError(failure.message)),
      (attendees) => emit(InstructorAttendeesLoaded(attendees)),
    );
  }

  Future<void> removeStudentFromAttendance(int courseId, String studentId) async {
    final currentState = state;
    if (currentState is InstructorAttendeesLoaded) {
      // Optimistically filter out the student from the local list
      final updatedList = currentState.attendees
          .where((student) => student.studentId != studentId)
          .toList();
      emit(InstructorAttendeesLoaded(updatedList));

      // Call repository to persist deletion in the database
      final result = await _repository.removeAttendanceRecord(
        courseId: courseId,
        studentId: studentId,
      );

      result.fold(
        (failure) {
          // Revert back or emit error if failed
          emit(InstructorAttendanceError(failure.message));
        },
        (success) {
          // Already updated the UI optimistically, so do nothing or trigger a silent refresh
        },
      );
    }
  }

  Future<void> fetchPastSessions(int courseId) async {
    emit(const InstructorAttendanceLoading());
    final result = await _repository.getCourseAttendanceReports(courseId);
    result.fold(
      (failure) => emit(InstructorAttendanceError(failure.message)),
      (reports) => emit(InstructorHistoryLoaded(reports)),
    );
  }
}
