import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bnu_lms_app/shared/error/remote_exception.dart';
import 'package:bnu_lms_app/shared/error/failure.dart';
import 'dart:io';
import 'package:bnu_lms_app/features/profile/domain/entities/profile_entity.dart';
import 'package:bnu_lms_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:bnu_lms_app/features/profile/data/data_sources/remote/profile_remote_data_source.dart';
import 'package:bnu_lms_app/features/profile/data/mappers/profile_mapper.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfileEntity>> getMyProfile() async {
    try {
      final remoteProfile = await remoteDataSource.getMyProfile();
      return Right(remoteProfile.toEntity());
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return const Left(Failure('An unexpected error occurred.'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final url = await remoteDataSource.uploadProfilePicture(file);
      return Right(url);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return const Left(Failure('An unexpected error occurred.'));
    }
  }
}
