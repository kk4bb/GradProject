import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_client.dart';
import '../config/api_constants.dart';

/// Handles authentication by calling the CampusConnect .NET API.
class AuthService {
  final Dio _dio = ApiClient.instance.dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Login → returns the JWT token string on success.
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );

    final token = response.data['token'] as String;

    // Save token securely for future requests
    await _storage.write(key: 'jwt_token', value: token);

    return token;
  }

  /// Register a new user.
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String role, // e.g. "Student", "Instructor"
  }) async {
    await _dio.post(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        'fullName': fullName,
        'role': role,
      },
    );
  }

  /// Clear the saved token (logout).
  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }

  /// Check if the user is already logged in.
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null && token.isNotEmpty;
  }
}
