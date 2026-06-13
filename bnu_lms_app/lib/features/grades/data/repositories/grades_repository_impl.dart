import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/error/failure.dart';
import '../../domain/entities/grade_entity.dart';
import '../../domain/repositories/grades_repository.dart';
import '../data_sources/remote/grades_remote_data_source.dart';

@Injectable(as: GradesRepository)
class GradesRepositoryImpl implements GradesRepository {
  final GradesRemoteDataSource remoteDataSource;

  GradesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, GradeEntity>> getStudentGrades(int courseId, String studentId) async {
    try {
      final gradeModel = await remoteDataSource.getStudentGrades(courseId, studentId);
      return Right(gradeModel);
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 404) {
          // Return an empty GradeEntity instead of crashing or showing error
          return Right(GradeEntity(
            id: 0,
            studentId: studentId,
            studentName: 'Student',
            courseId: courseId,
            quizzesTotal: 0,
            assignmentsTotal: 0,
            attendanceTotal: 0,
            projectGrade: 0,
            midterm1: 0,
            midterm2: 0,
            finalExam: 0,
            isTermWorkPublished: false,
            totalGrade: 0,
          ));
        }
        final data = e.response!.data;
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          return Left(Failure(data['message'] ?? 'Failed to fetch grades'));
        }
        return Left(Failure(e.response!.statusMessage ?? 'Failed to fetch grades'));
      }
      return const Left(Failure('Network error occurred'));
    } catch (e) {
      return Left(const Failure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<GradeEntity>>> getCourseGrades(int courseId) async {
    try {
      final gradeModels = await remoteDataSource.getCourseGrades(courseId);
      return Right(gradeModels);
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          return Left(Failure(data['message'] ?? 'Failed to fetch course grades'));
        }
        return Left(Failure(e.response!.statusMessage ?? 'Failed to fetch course grades'));
      }
      return const Left(Failure('Network error occurred'));
    } catch (e) {
      return Left(const Failure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, GradeEntity>> updateGrades(int courseId, String studentId, Map<String, dynamic> updateData) async {
    try {
      final updatedModel = await remoteDataSource.updateGrades(courseId, studentId, updateData);
      return Right(updatedModel);
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          return Left(Failure(data['message'] ?? 'Failed to update grades'));
        }
        return Left(Failure(e.response!.statusMessage ?? 'Failed to update grades'));
      }
      return const Left(Failure('Network error occurred'));
    } catch (e) {
      return Left(const Failure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> publishTermWork(int courseId) async {
    try {
      await remoteDataSource.publishTermWork(courseId);
      return const Right(null);
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          return Left(Failure(data['message'] ?? 'Failed to publish term work'));
        }
        return Left(Failure(e.response!.statusMessage ?? 'Failed to publish term work'));
      }
      return const Left(Failure('Network error occurred'));
    } catch (e) {
      return Left(const Failure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> unlockTermWork(int courseId) async {
    try {
      await remoteDataSource.unlockTermWork(courseId);
      return const Right(null);
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          return Left(Failure(data['message'] ?? 'Failed to unlock term work'));
        }
        return Left(Failure(e.response!.statusMessage ?? 'Failed to unlock term work'));
      }
      return const Left(Failure('Network error occurred'));
    } catch (e) {
      return Left(const Failure('An unexpected error occurred'));
    }
  }
}
