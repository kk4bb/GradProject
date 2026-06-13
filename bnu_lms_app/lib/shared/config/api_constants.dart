/// API Configuration for CampusConnect .NET Backend
///
/// 🖥️  Running on Android Emulator?  → use 10.0.2.2  (maps to your PC's localhost)
/// 📱  Running on Physical Device?   → use your PC's local IP  e.g. 192.168.1.x
/// 🌐  Running on Web / Desktop?     → use localhost
class ApiConstants {
  // ─── Base URL ────────────────────────────────────────────────────────────────
  /// Change this to your PC's local IP when running on a real device.
  /// The .NET API runs on http://localhost:5205 (see launchSettings.json)
  // static const String _androidEmulatorHost = '10.0.2.2';
  static const String _localHost = '130.110.249.137';
  static const int _port = 5205;

  /// ✅ Physical device on same WiFi → uses PC local IP (130.110.249.137)
  /// ✅ Android Emulator → change to _androidEmulatorHost (10.0.2.2)
  /// ✅ Web/Windows app → change to 'localhost'
  static const String baseUrl = 'http://$_localHost:$_port/api/';

  /// ✅ SignalR Hubs should use this URL to dynamically route correctly
  static String hubUrl(String hubPath) => 'http://$_localHost:$_port/$hubPath';

  /// ✅ For assets like profile images stored on the server
  static String fullUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return 'http://$_localHost:$_port${path.startsWith('/') ? path : '/$path'}';
  }

  // ─── Auth Endpoints ───────────────────────────────────────────────────────
  static const String login = '${baseUrl}auth/login';
  static const String register = '${baseUrl}auth/register';

  // ─── Student Endpoints ────────────────────────────────────────────────────
  static const String students = '${baseUrl}student';
  static const String studentProfileMe = '${baseUrl}student/profile/me';

  // ─── Course Endpoints ─────────────────────────────────────────────────────
  static const String courses = '${baseUrl}course';

  // ─── Quiz Endpoints ───────────────────────────────────────────────────────
  static const String quizzes = '${baseUrl}quiz';



  // ─── Forum Endpoints ──────────────────────────────────────────────────────
  static const String forums = '${baseUrl}forum';

  // ─── Attendance Endpoints ─────────────────────────────────────────────────
  static const String attendance = '${baseUrl}attendance';

  // ─── Notification Endpoints ───────────────────────────────────────────────────
  static const String notifications = '${baseUrl}Notification';
  static const String announcements = '${baseUrl}Announcement';
  static String courseAnnouncements(int courseId) => '${baseUrl}Announcement/course/$courseId';

  // ─── Assignment Endpoints (must stay under [baseUrl] — missing `api` or a double slash → 404) ──
  static String assignmentCourseList(int courseId) => '${baseUrl}Assignment/course/$courseId';
  static String assignmentDetail(int assignmentId) => '${baseUrl}Assignment/$assignmentId';
  static String get assignmentCreate => '${baseUrl}Assignment/create';
  static String assignmentSubmit(int assignmentId) => '${baseUrl}Assignment/$assignmentId/submit';
  static String assignmentSubmissions(int assignmentId) => '${baseUrl}Assignment/$assignmentId/submissions';
  static String submissionGrade(int submissionId) => '${baseUrl}Assignment/submission/$submissionId/grade';

  // ─── Calendar Endpoints ───────────────────────────────────────────────────
  static const String calendar = '${baseUrl}Calendar';

  // ─── AI Chat Endpoints ────────────────────────────────────────────────────
  static const String aiSessions = '${baseUrl}ai/sessions';
  static String aiSessionMessages(int sessionId) => '${baseUrl}ai/sessions/$sessionId/messages';
  static const String aiMessage = '${baseUrl}ai/message';
  static String aiDeleteSession(int sessionId) => '${baseUrl}ai/sessions/$sessionId';

  // ─── Local Storage Keys ────────────────────────────────────────────────────
  static const String tokenKey = 'jwt_token';
}
