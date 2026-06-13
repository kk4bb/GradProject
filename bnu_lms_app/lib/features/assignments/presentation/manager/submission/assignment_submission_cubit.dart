import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/repositories/assignment_repository.dart';
import 'assignment_submission_state.dart';

@injectable
class AssignmentSubmissionCubit extends Cubit<AssignmentSubmissionState> {
  final AssignmentRepository _repository;

  AssignmentSubmissionCubit(this._repository) : super(const AssignmentSubmissionState.initial());

  Future<void> submitAssignment({
    required int assignmentId,
    required String? filePath,
    required String? url,
    required String? comment,
  }) async {
    if ((filePath == null || filePath.isEmpty) && (url == null || url.isEmpty)) {
      emit(const AssignmentSubmissionState.error("Please provide either a file or a URL."));
      return;
    }

    emit(const AssignmentSubmissionState.loading());

    final submissionData = {
      if (filePath != null) 'filePath': filePath,
      if (url != null) 'url': url,
      if (comment != null) 'comment': comment,
    };

    final result = await _repository.submitAssignment(assignmentId, submissionData);

    result.fold(
      (failure) => emit(AssignmentSubmissionState.error(failure.message)),
      (_) => emit(const AssignmentSubmissionState.success()),
    );
  }
}
