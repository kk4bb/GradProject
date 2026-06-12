import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/assignment_entity.dart';

part 'student_assignments_state.freezed.dart';

@freezed
class StudentAssignmentsState with _$StudentAssignmentsState {
  const factory StudentAssignmentsState.initial() = _Initial;
  const factory StudentAssignmentsState.loading() = _Loading;
  const factory StudentAssignmentsState.success(List<AssignmentEntity> assignments) = _Success;
  const factory StudentAssignmentsState.error(String message) = _Error;
}
