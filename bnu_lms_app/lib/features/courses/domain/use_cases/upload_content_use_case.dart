// lib/features/courses/domain/use_cases/upload_content_use_case.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../repositories/course_repository.dart';

@lazySingleton
class UploadContentUseCase {
  final CourseRepository _repository;

  const UploadContentUseCase(this._repository);

  Future<Either<Failure, int>> call({
    required int lessonId,
    required String contentType,
    required String filePath,
    required String fileName,
  }) {
    return _repository.uploadContent(
      lessonId: lessonId,
      contentType: contentType,
      filePath: filePath,
      fileName: fileName,
    );
  }
}
