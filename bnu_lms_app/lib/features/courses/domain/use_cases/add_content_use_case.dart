// lib/features/courses/domain/use_cases/add_content_use_case.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../repositories/course_repository.dart';

@lazySingleton
class AddContentUseCase {
  final CourseRepository _repository;

  const AddContentUseCase(this._repository);

  Future<Either<Failure, int>> call({
    required int lessonId,
    required String type,
    required String url,
  }) {
    return _repository.addContent(lessonId: lessonId, type: type, url: url);
  }
}
