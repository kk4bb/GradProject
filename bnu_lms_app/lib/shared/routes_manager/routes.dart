class Routes {
  // -- Auth & Onboarding --
  static const String onBoarding = '/onboarding';
  static const String login = "/login";
  static const String register = "/register";

  // -- Core Navigation --
  static const String main = '/main'; // Main Layout (Bottom Nav)
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String aiChat = '/aiChat';

  // -- Student Features --
  static const String courses = "/courses";
  static const String coursesDetails = "/coursesDetails";
  static const String calendar = "/calendar";
  static const String grades = "/grades";
  static const String attendance = "/attendance";
  static const String entrance = "/entrance";
  static const String forumsDetails = "/forumsDetails";

  // -- Student Quizzes --
  static const String quizzes = "/quizzes";
  static const String quizDetails = "/quizDetails";
  static const String quizQuestions = "/quizQuestions";
  static const String quizResults = "/quizResults";

  // -- Doctor Features --
  static const String doctorDashboard = '/doctorDashboard';
  static const String doctorCoursesDetails = '/doctorCoursesDetails';
  static const String doctorQuestionDetails = '/doctorQuestionDetails';


// -- TA Features --
  static const String taDashboard = '/taDashboard';
  static const String taCoursesDetails = '/taCoursesDetails';
  static const String taAssignmentGrades = '/taAssignmentGrades';
}