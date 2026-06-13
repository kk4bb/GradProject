// lib/features/auth/data/data_sources/remote/auth_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../../shared/config/api_constants.dart';
import '../../../../../shared/error/remote_exception.dart';
import '../../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({required String email, required String password});
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  const AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );
      return AuthModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      final msg = e.response?.data?['message'] as String? ??
          e.response?.data?.toString() ??
          'Login failed. Please check your connection.';
      throw RemoteException(message: msg);
    }
  }
}
