import 'package:dartz/dartz.dart';
import 'package:bnu_lms_app/shared/error/failure.dart';
import '../../domain/entities/assignment_entity.dart';
import '../../domain/entities/submission_entity.dart';

abstract class AssignmentRepository {
  Future<Either<Failure, List<AssignmentEntity>>> getAssignmentsByCourse(int courseId);
  Future<Either<Failure, AssignmentEntity>> getAssignmentDetail(int assignmentId);
  Future<Either<Failure, int>> createAssignment(int courseId, Map<String, dynamic> assignmentData);
  Future<Either<Failure, void>> submitAssignment(int assignmentId, Map<String, dynamic> submissionData);
  Future<Either<Failure, List<SubmissionEntity>>> getSubmissions(int assignmentId);
  Future<Either<Failure, void>> gradeSubmission(int submissionId, double grade, String feedback);
}
