import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_constants.dart';

/// Singleton Dio client pre-configured for the CampusConnect .NET API.
/// Automatically attaches the JWT Bearer token to every request.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  late final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  )..interceptors.add(_AuthInterceptor(_storage));
}

/// Interceptor that reads the stored JWT and injects it as a Bearer token.
class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;
  _AuthInterceptor(this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip adding auth header for login and register requests
    if (options.path.contains('auth/login') || options.path.contains('auth/register')) {
      return handler.next(options);
    }

    final token = await _storage.read(key: 'jwt_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // You can add global error handling here (e.g. 401 → logout)
    handler.next(err);
  }
}
