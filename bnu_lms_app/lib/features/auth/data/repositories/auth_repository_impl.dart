// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../../../../shared/error/remote_exception.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote/auth_remote_data_source.dart';
import '../mappers/auth_mappers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/config/api_constants.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final FlutterSecureStorage _storage;

  const AuthRepositoryImpl(this._remoteDataSource, this._storage);

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      final entity = model.toEntity;

      // Persist credentials for app-wide use
      await _storage.write(key: 'jwt_token',  value: entity.token);
      await _storage.write(key: 'user_role',  value: entity.role.name);
      await _storage.write(key: 'user_email', value: entity.email);

      return Right(entity);
    } on RemoteException catch (e) {
      return Left(Failure(e.message));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<void> logout() async {
    await _storage.deleteAll();
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.remove(ApiConstants.tokenKey);
  }
}
