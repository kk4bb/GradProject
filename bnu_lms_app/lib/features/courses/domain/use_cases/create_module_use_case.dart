// lib/features/courses/domain/use_cases/create_module_use_case.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../repositories/course_repository.dart';

@lazySingleton
class CreateModuleUseCase {
  final CourseRepository _repository;

  const CreateModuleUseCase(this._repository);

  Future<Either<Failure, int>> call({
    required int courseId,
    required String title,
  }) {
    return _repository.createModule(courseId: courseId, title: title);
  }
}
