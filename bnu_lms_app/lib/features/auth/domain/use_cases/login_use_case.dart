// lib/features/auth/domain/use_cases/login_use_case.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../shared/error/failure.dart';
import '../entities/auth_entity.dart';
import '../repositories/auth_repository.dart';

@lazySingleton
class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<Either<Failure, AuthEntity>> call({
    required String email,
    required String password,
  }) =>
      _repository.login(email: email, password: password);
}
