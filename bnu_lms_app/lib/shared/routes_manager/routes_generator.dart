import 'package:flutter/material.dart';

// Use absolute imports consistently for a cleaner file header
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:bnu_lms_app/features/ai_chat/presentation/screens/ai_chat_screen.dart';
import 'package:bnu_lms_app/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:bnu_lms_app/features/auth/presentation/screens/login_screen.dart';
import 'package:bnu_lms_app/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:bnu_lms_app/features/courses/presentation/doctor/presentation/screens/doctor_courses_details_screen.dart';
import 'package:bnu_lms_app/features/courses/presentation/student/screens/courses_details_screen.dart';
import 'package:bnu_lms_app/features/forums/doctor/presentation/screens/doctor_question_details_screen.dart';
import 'package:bnu_lms_app/features/forums/student/presentation/screens/forums_details_screen.dart';
import 'package:bnu_lms_app/features/gate/presentation/screens/gate_screen.dart';
import 'package:bnu_lms_app/features/grades/presentation/screens/grades_screen.dart';
import 'package:bnu_lms_app/features/home/presentation/doctor/presentation/screens/doctor_home_screen.dart';
import 'package:bnu_lms_app/features/home/presentation/student/screen/home_screen.dart';
import 'package:bnu_lms_app/features/notification/presentation/screens/notifications_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/screens/quiz_details_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/screens/quiz_questions_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/screens/quiz_results_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/screens/quizzes_screen.dart';

import '../../features/settings/presentation/screens/settings_screen.dart';

class RoutesGenerator {
  static Route<dynamic>? getRoute(RouteSettings settings) {
    // Extract args once here if you want to keep the switch cases cleaner
    final args = settings.arguments as Map<String, dynamic>?;

    switch (settings.name) {
    // -------------------------
    // CORE ROUTES
    // -------------------------
      case Routes.main:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case Routes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.aiChat:
        return MaterialPageRoute(builder: (_) => const AiChatScreen());

    // -------------------------
    // CATEGORY ROUTES
    // -------------------------
      case Routes.calendar:
        return MaterialPageRoute(builder: (_) => const CalendarScreen());
      case Routes.quizzes:
        return MaterialPageRoute(builder: (_) => const QuizzesScreen());
      case Routes.grades:
        return MaterialPageRoute(builder: (_) => const GradesScreen());
      case Routes.attendance:
        return MaterialPageRoute(builder: (_) => const AttendanceScreen());
      case Routes.entrance:
        return MaterialPageRoute(builder: (_) => const GateScreen());

    // -------------------------
    // QUIZ ROUTES
    // -------------------------
      case Routes.quizDetails:
        return MaterialPageRoute(builder: (_) => const QuizDetailsScreen());
      case Routes.quizQuestions:
        return MaterialPageRoute(builder: (_) => const QuizQuestionsScreen());
      case Routes.quizResults:
        return MaterialPageRoute(builder: (_) => const QuizResultsScreen());

    // -------------------------
    // FORUMS ROUTES
    // -------------------------
      case Routes.forumsDetails:
        final forumTitle = args?['forumTitle'] as String? ?? 'Forum Discussion';
        return MaterialPageRoute(
          builder: (_) => ForumsDetailsScreen(forumTitle: forumTitle),
        );

    // -------------------------
    // COURSE ROUTES
    // -------------------------
      case Routes.coursesDetails:
        if (args == null) return _unDefinedRoute();

        return MaterialPageRoute(
          builder: (_) => CourseDetailsScreen(
            courseTitle: args['courseTitle'] as String? ?? 'Unknown Course',
            instructor: args['instructor'] as String? ?? 'Unknown Instructor',
            courseCode: args['courseCode'] as String? ?? 'N/A',
            icon: args['icon'] as IconData? ?? Icons.computer,
          ),
        );

    // -------------------------
    // DOCTOR VIEW ROUTES
    // -------------------------
      case Routes.doctorDashboard:
        return MaterialPageRoute(builder: (_) => const DoctorHomeScreen());

      case Routes.doctorCoursesDetails:
        return MaterialPageRoute(builder: (_) => const DoctorCourseDetailsScreen());

      case Routes.doctorQuestionDetails: // Fixed duplicate case name
        if (args == null || !args.containsKey('questionData')) return _unDefinedRoute();

        return MaterialPageRoute(
          builder: (_) => DoctorQuestionDetailsScreen(
            questionData: args['questionData'] as Map<String, dynamic>, // Fixed syntax error
          ),
        );

      default:
        return _unDefinedRoute();
    }
  }

  static Route<dynamic> _unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('No Route Found')),
        body: const Center(child: Text('Route not found')),
      ),
    );
  }
}