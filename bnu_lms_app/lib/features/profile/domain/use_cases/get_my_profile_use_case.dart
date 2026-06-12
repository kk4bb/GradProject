import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bnu_lms_app/shared/error/failure.dart';
import 'package:bnu_lms_app/features/profile/domain/entities/profile_entity.dart';
import 'package:bnu_lms_app/features/profile/domain/repositories/profile_repository.dart';

@lazySingleton
class GetMyProfileUseCase {
  final ProfileRepository repository;

  GetMyProfileUseCase(this.repository);

  Future<Either<Failure, ProfileEntity>> call() async {
    return await repository.getMyProfile();
  }
}
