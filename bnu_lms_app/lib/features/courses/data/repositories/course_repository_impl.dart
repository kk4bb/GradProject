// lib/features/courses/data/repositories/course_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../../../../shared/error/remote_exception.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/course_repository.dart';
import '../data_sources/remote/course_remote_data_source.dart';
import '../mappers/course_mapper.dart';

@LazySingleton(as: CourseRepository)
class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource _remoteDataSource;

  const CourseRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<CourseSummaryEntity>>> getEnrolledCourses() async {
    try {
      final models = await _remoteDataSource.getEnrolledCourses();
      return Right(models.map((m) => m.toEntity).toList());
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to fetch courses: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<CourseSummaryEntity>>> getAssignedCourses() async {
    try {
      final models = await _remoteDataSource.getAssignedCourses();
      return Right(models.map((m) => m.toEntity).toList());
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to fetch assigned courses: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, CourseDetailEntity>> getCourseDetails(int id) async {
    try {
      final model = await _remoteDataSource.getCourseDetails(id);
      return Right(model.toEntity);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to fetch course details: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> createModule({
    required int courseId,
    required String title,
  }) async {
    try {
      final id = await _remoteDataSource.createModule(courseId, title);
      return Right(id);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to create module: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> addLesson({
    required int moduleId,
    required String title,
  }) async {
    try {
      final id = await _remoteDataSource.addLesson(moduleId, title);
      return Right(id);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to add lesson: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, int>> addContent({
    required int lessonId,
    required String type,
    required String url,
  }) async {
    try {
      final id = await _remoteDataSource.addContent(lessonId, type, url);
      return Right(id);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Failed to add content: ${e.toString()}'));
    }
  }
}
