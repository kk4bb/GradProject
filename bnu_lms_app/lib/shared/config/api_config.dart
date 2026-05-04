import '../network/api_endpoints.dart';

class ApiConfig {
  static const String baseUrl = "http://localhost:5205/api/";
  
  // Endpoints (proxied from ApiEndpoints for backward compatibility if needed)
  static const String login = ApiEndpoints.login;
  static const String studentMe = ApiEndpoints.studentDashboard;
}
