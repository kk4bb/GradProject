import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bnu_lms_app/shared/error/failure.dart';
import '../../domain/entities/assignment_entity.dart';
import '../../domain/entities/submission_entity.dart';
import '../../domain/repositories/assignment_repository.dart';
import '../data_sources/remote/assignment_remote_data_source.dart';

@LazySingleton(as: AssignmentRepository)
class AssignmentRepositoryImpl implements AssignmentRepository {
  final AssignmentRemoteDataSource _remoteDataSource;

  AssignmentRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<AssignmentEntity>>> getAssignmentsByCourse(int courseId) async {
    try {
      final models = await _remoteDataSource.getAssignmentsByCourse(courseId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AssignmentEntity>> getAssignmentDetail(int assignmentId) async {
    try {
      final model = await _remoteDataSource.getAssignmentDetail(assignmentId);
      return Right(model.toEntity());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> createAssignment(int courseId, Map<String, dynamic> assignmentData) async {
    try {
      final id = await _remoteDataSource.createAssignment(courseId, assignmentData);
      return Right(id);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitAssignment(int assignmentId, Map<String, dynamic> submissionData) async {
    try {
      await _remoteDataSource.submitAssignment(assignmentId, submissionData);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SubmissionEntity>>> getSubmissions(int assignmentId) async {
    try {
      final models = await _remoteDataSource.getSubmissions(assignmentId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> gradeSubmission(int submissionId, double grade, String feedback) async {
    try {
      await _remoteDataSource.gradeSubmission(submissionId, grade, feedback);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
