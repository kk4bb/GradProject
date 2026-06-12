// lib/features/courses/domain/repositories/course_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../shared/error/failure.dart';
import '../entities/course_entity.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<CourseSummaryEntity>>> getEnrolledCourses();
  
  Future<Either<Failure, List<CourseSummaryEntity>>> getAssignedCourses();
  
  Future<Either<Failure, CourseDetailEntity>> getCourseDetails(int id);
  
  Future<Either<Failure, int>> createModule({
    required int courseId,
    required String title,
  });
  
  Future<Either<Failure, int>> addLesson({
    required int moduleId,
    required String title,
  });
  
  Future<Either<Failure, int>> addContent({
    required int lessonId,
    required String type,
    required String url,
  });
}
