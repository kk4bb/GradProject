import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignment_submission_state.freezed.dart';

@freezed
class AssignmentSubmissionState with _$AssignmentSubmissionState {
  const factory AssignmentSubmissionState.initial() = _Initial;
  const factory AssignmentSubmissionState.loading() = _Loading;
  const factory AssignmentSubmissionState.success() = _Success;
  const factory AssignmentSubmissionState.error(String message) = _Error;
}
