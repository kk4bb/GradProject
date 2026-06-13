import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bnu_lms_app/shared/error/failure.dart';
import 'package:bnu_lms_app/features/profile/domain/repositories/profile_repository.dart';

@lazySingleton
class UploadProfilePictureUseCase {
  final ProfileRepository repository;

  UploadProfilePictureUseCase(this.repository);

  Future<Either<Failure, String>> call(File file) {
    return repository.uploadProfilePicture(file);
  }
}
