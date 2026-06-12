// lib/features/courses/domain/use_cases/add_lesson_use_case.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../repositories/course_repository.dart';

@lazySingleton
class AddLessonUseCase {
  final CourseRepository _repository;

  const AddLessonUseCase(this._repository);

  Future<Either<Failure, int>> call({
    required int moduleId,
    required String title,
  }) {
    return _repository.addLesson(moduleId: moduleId, title: title);
  }
}
