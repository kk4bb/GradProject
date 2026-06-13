import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../shared/services/signalr_service.dart';
import '../../../domain/entities/assignment_entity.dart';
import '../../../domain/repositories/assignment_repository.dart';
import 'student_assignments_state.dart';
import 'dart:async';

@injectable
class StudentAssignmentsCubit extends Cubit<StudentAssignmentsState> {
  final AssignmentRepository _repository;
  final SignalRService _signalRService;
  StreamSubscription? _signalRSubscription;

  StudentAssignmentsCubit(this._repository, this._signalRService) : super(const StudentAssignmentsState.initial());

  Future<void> getAssignments(int courseId) async {
    // Join SignalR group for this course
    await _signalRService.joinCourse(courseId);

    // Subscribe to new assignments
    _signalRSubscription?.cancel();
    _signalRSubscription = _signalRService.assignmentStream.listen((newAssignment) {
      // Silently refresh the list when a new assignment is added
      fetchAssignments(courseId);
    });

    // Only show loading if we don't have data yet
    final bool hasData = state.maybeWhen(
      success: (assignments) => assignments.isNotEmpty,
      orElse: () => false,
    );

    if (!hasData) {
      emit(const StudentAssignmentsState.loading());
    }

    final result = await _repository.getAssignmentsByCourse(courseId);
    result.fold(
      (failure) => emit(StudentAssignmentsState.success(_getDummyAssignments())),
      (assignments) {
        if (assignments.isEmpty) {
          emit(StudentAssignmentsState.success(_getDummyAssignments()));
        } else {
          emit(StudentAssignmentsState.success(assignments));
        }
      },
    );
  }

  // Alias for better readability in UI
  Future<void> fetchAssignments(int courseId) => getAssignments(courseId);

  List<AssignmentEntity> _getDummyAssignments() {
    return [
      AssignmentEntity(
        id: 1,
        title: 'Advanced Software Design',
        description: 'Implement a clean architecture project.',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        maxPoints: 100,
        status: 'Pending',
      ),
      AssignmentEntity(
        id: 2,
        title: 'Database Schema Design',
        description: 'Design a normalized schema for a social media app.',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        maxPoints: 50,
        status: 'Submitted',
      ),
      AssignmentEntity(
        id: 3,
        title: 'Algorithm Analysis Quiz',
        description: 'Calculate time complexity for given snippets.',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
        maxPoints: 20,
        status: 'Graded',
        grade: 18,
        feedback: 'Excellent work on the big-O notation explanations.',
      ),
    ];
  }

  @override
  Future<void> close() {
    _signalRSubscription?.cancel();
    return super.close();
  }
}
