// lib/features/courses/domain/use_cases/get_assigned_courses_use_case.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

@lazySingleton
class GetAssignedCoursesUseCase {
  final CourseRepository _repository;

  const GetAssignedCoursesUseCase(this._repository);

  Future<Either<Failure, List<CourseSummaryEntity>>> call() {
    return _repository.getAssignedCourses();
  }
}
