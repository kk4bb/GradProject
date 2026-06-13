// lib/features/courses/domain/use_cases/get_course_details_use_case.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

@lazySingleton
class GetCourseDetailsUseCase {
  final CourseRepository _repository;

  const GetCourseDetailsUseCase(this._repository);

  Future<Either<Failure, CourseDetailEntity>> call(int id) {
    return _repository.getCourseDetails(id);
  }
}
