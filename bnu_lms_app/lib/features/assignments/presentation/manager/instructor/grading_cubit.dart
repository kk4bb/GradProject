import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/assignment_repository.dart';
import 'grading_state.dart';

@injectable
class GradingCubit extends Cubit<GradingState> {
  final AssignmentRepository _repository;

  GradingCubit(this._repository) : super(const GradingState.initial());

  Future<void> getSubmissions(int assignmentId) async {
    emit(const GradingState.loading());
    final result = await _repository.getSubmissions(assignmentId);
    result.fold(
      (failure) => emit(GradingState.error(failure.message)),
      (submissions) => emit(GradingState.submissionsLoaded(submissions)),
    );
  }

  Future<void> gradeSubmission({
    required int submissionId,
    required double grade,
    required String feedback,
  }) async {
    emit(const GradingState.loading());
    final result = await _repository.gradeSubmission(submissionId, grade, feedback);
    result.fold(
      (failure) => emit(GradingState.error(failure.message)),
      (_) => emit(const GradingState.success()),
    );
  }
}
