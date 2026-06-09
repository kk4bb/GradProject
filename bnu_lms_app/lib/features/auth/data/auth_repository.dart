import 'package:dio/dio.dart';
import '../../../shared/config/api_config.dart';
import '../../../shared/network/api_service.dart';

class AuthResponse {
  final String token;
  final DateTime expiration;
  final String email;
  final String role;
  final String firstName;
  final String lastName;

  AuthResponse({
    required this.token,
    required this.expiration,
    required this.email,
    required this.role,
    required this.firstName,
    required this.lastName,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      expiration: DateTime.parse(json['expiration']),
      email: json['email'],
      role: json['role'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
    );
  }
}

class AuthRepository {
  final Dio _dio = apiService.dio;

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConfig.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data);
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      String errorMessage = 'An error occurred during login';
      if (e.response != null && e.response?.data != null) {
        // Backend usually returns plain string for these exceptions or a ProblemDetails object
        errorMessage = e.response?.data.toString() ?? errorMessage;
      }
      throw Exception(errorMessage);
    }
  }
}
