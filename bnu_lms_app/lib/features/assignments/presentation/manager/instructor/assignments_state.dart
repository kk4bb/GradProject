import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/assignment_entity.dart';

part 'assignments_state.freezed.dart';

@freezed
class AssignmentsState with _$AssignmentsState {
  const factory AssignmentsState.initial() = _Initial;
  const factory AssignmentsState.loading() = _Loading;
  const factory AssignmentsState.success(List<AssignmentEntity> assignments) = _Success;
  const factory AssignmentsState.error(String message) = _Error;
  const factory AssignmentsState.created() = _Created;
}
