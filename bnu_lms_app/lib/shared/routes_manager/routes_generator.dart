import 'package:bnu_lms_app/features/courses/presentation/ta/presentation/screens/ta_assignment_grade_screen.dart';
import 'package:bnu_lms_app/features/home/presentation/ta/presentation/screens/ta_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Use absolute imports consistently for a cleaner file header
import 'package:bnu_lms_app/shared/di/injection.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_list_cubit.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_taking_cubit.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_grading_cubit.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/cubit/quiz_results_cubit.dart';
import 'package:bnu_lms_app/shared/routes_manager/routes.dart';
import 'package:bnu_lms_app/features/ai_chat/presentation/screens/ai_chat_screen.dart';
import 'package:bnu_lms_app/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:bnu_lms_app/features/attendance/presentation/screens/attendance_screen.dart';
import 'package:bnu_lms_app/features/auth/presentation/screens/login_screen.dart';
import 'package:bnu_lms_app/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:bnu_lms_app/features/courses/presentation/doctor/presentation/screens/doctor_courses_details_screen.dart';
import 'package:bnu_lms_app/features/courses/presentation/doctor/presentation/screens/lecture_attendance_details_screen.dart';
import 'package:bnu_lms_app/features/courses/presentation/student/screens/courses_details_screen.dart';

import 'package:bnu_lms_app/features/grades/presentation/student/screens/grades_dashboard_screen.dart';
import 'package:bnu_lms_app/features/courses/presentation/cubit/courses_cubit/courses_cubit.dart';

import 'package:bnu_lms_app/features/notification/presentation/screens/notifications_screen.dart';
import 'package:bnu_lms_app/features/notification/presentation/screens/notification_details_screen.dart';
import 'package:bnu_lms_app/features/notification/presentation/instructor/screens/instructor_manage_announcements_screen.dart';
import 'package:bnu_lms_app/features/notification/presentation/ta/screens/ta_section_announcements_screen.dart';
import 'package:bnu_lms_app/features/notification/presentation/instructor/screens/create_announcement_screen.dart';
import 'package:bnu_lms_app/features/notification/presentation/screens/notification_preferences_screen.dart';
import 'package:bnu_lms_app/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/screens/quiz_details_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/screens/quiz_questions_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/screens/student_quiz_dashboard_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/screens/quiz_creation_wizard_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/student/screens/quiz_intro_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/student/screens/active_quiz_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/student/screens/quiz_submit_screen.dart';
import 'package:bnu_lms_app/features/quizzes/presentation/student/screens/quiz_results_screen.dart';

import '../../features/courses/presentation/ta/presentation/screens/ta_course_details_screen.dart';
import '../../features/forums/presentation/doctor/presentation/screens/doctor_question_details_screen.dart';
import '../../features/forums/domain/entities/forum_entities.dart';
import '../../features/forums/presentation/student/presentation/screens/forums_details_screen.dart';
import '../../features/home/presentation/doctor/presentation/screens/doctor_home_screen.dart';
import '../../features/home/presentation/student/screen/home_screen.dart';
import '../../features/quizzes/domain/entities/quiz_entity.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/help_center_screen.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';

class RoutesGenerator {
  static Route<dynamic>? getRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      // -------------------------
      // CORE ROUTES
      // -------------------------
      case Routes.main:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case Routes.editProfile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<ProfileCubit>(),
            child: const EditProfileScreen(),
          ),
        );
      case Routes.helpCenter:
        return MaterialPageRoute(builder: (_) => const HelpCenterScreen());
      case Routes.notifications:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<NotificationCubit>()..getNotifications(),
            child: const NotificationsScreen(),
          ),
        );
      case Routes.notificationDetails:
        final notificationArgs = args as Map<String, dynamic>?;
        if (notificationArgs == null || !notificationArgs.containsKey('notification')) return _unDefinedRoute();
        return MaterialPageRoute(
          builder: (_) => NotificationDetailsScreen(
            notification: notificationArgs['notification'],
          ),
        );
      case Routes.manageAnnouncements:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<NotificationCubit>()),
              BlocProvider(create: (_) => getIt<CoursesCubit>()),
            ],
            child: const InstructorManageAnnouncementsScreen(),
          ),
        );
      case Routes.sectionAnnouncements:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<NotificationCubit>(),
            child: const TaSectionAnnouncementsScreen(),
          ),
        );
      case Routes.createAnnouncement:
        final announcementArgs = args as Map<String, dynamic>?;
        final editAnnouncement = announcementArgs?['announcement'];
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<NotificationCubit>()),
              BlocProvider.value(value: getIt<CoursesCubit>()),
            ],
            child: CreateAnnouncementScreen(editAnnouncement: editAnnouncement),
          ),
        );
      case Routes.notificationPreferences:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: getIt<NotificationCubit>(),
            child: const NotificationPreferencesScreen(),
          ),
        );
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
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizListCubit>(),
            child: const StudentQuizDashboardScreen(),
          ),
        );
      case Routes.grades:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<CoursesCubit>(),
            child: const GradesDashboardScreen(),
          ),
        );
      case Routes.attendance:
        return MaterialPageRoute(builder: (_) => const AttendanceScreen());

      case Routes.quizWizard:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<QuizGradingCubit>()),
              BlocProvider(create: (_) => getIt<CoursesCubit>()),
            ],
            child: const QuizCreationWizardScreen(),
          ),
        );

      // -------------------------
      // QUIZ ROUTES
      // -------------------------
      case Routes.quizDetails:
        final detailArgs = args as Map<String, dynamic>?;
        if (detailArgs == null || !detailArgs.containsKey('quiz')) return _unDefinedRoute();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizGradingCubit>(),
            child: QuizDetailsScreen(quiz: detailArgs['quiz'] as QuizEntity),
          ),
        );
      case Routes.quizQuestions:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizGradingCubit>(),
            child: const QuizQuestionsScreen(),
          ),
        );
      case Routes.quizResults:
        final resultsArgs = args as Map<String, dynamic>?;
        if (resultsArgs == null || !resultsArgs.containsKey('quiz')) return _unDefinedRoute();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizResultsCubit>(),
            child: QuizResultsScreen(quiz: resultsArgs['quiz'] as QuizEntity),
          ),
        );
      case Routes.studentQuizDashboard:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizListCubit>(),
            child: const StudentQuizDashboardScreen(),
          ),
        );
      case Routes.quizIntro:
        final quizArgs = args as Map<String, dynamic>?;
        if (quizArgs == null || !quizArgs.containsKey('quiz')) return _unDefinedRoute();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizTakingCubit>(),
            child: QuizIntroScreen(quiz: quizArgs['quiz'] as QuizEntity),
          ),
        );
      case Routes.activeQuiz:
        final activeArgs = settings.arguments as Map<String, dynamic>?;
        final int quizId = activeArgs?['quizId'] ?? 0;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizTakingCubit>(),
            child: ActiveQuizScreen(quizId: quizId),
          ),
        );
      case Routes.quizSubmit:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<QuizTakingCubit>(),
            child: const QuizSubmitScreen(),
          ),
        );

      // -------------------------
      // FORUMS ROUTES
      // -------------------------
      case Routes.forumsDetails:
        final forumTitle = (args as Map<String, dynamic>?)?['forumTitle'] as String? ?? 'Forum Discussion';
        return MaterialPageRoute(
          builder: (_) => ForumsDetailsScreen(forumTitle: forumTitle),
        );

      // -------------------------
      // COURSE ROUTES
      // -------------------------
      case Routes.coursesDetails:
        final courseArgs = args as Map<String, dynamic>?;
        if (courseArgs == null || !courseArgs.containsKey('courseId')) return _unDefinedRoute();

        return MaterialPageRoute(
          builder: (_) => CourseDetailsScreen(
            courseId: courseArgs['courseId'] as int,
            courseTitle: courseArgs['courseTitle'] as String? ?? 'Unknown Course',
            instructor: courseArgs['instructor'] as String? ?? 'Unknown Instructor',
            courseCode: courseArgs['courseCode'] as String? ?? 'N/A',
            icon: courseArgs['icon'] as IconData? ?? Icons.computer,
          ),
        );

      // -------------------------
      // DOCTOR VIEW ROUTES
      // -------------------------
      case Routes.doctorDashboard:
        return MaterialPageRoute(builder: (_) => const DoctorHomeScreen());

      case Routes.doctorCoursesDetails:
        final doctorCourseArgs = args as Map<String, dynamic>?;
        if (doctorCourseArgs == null || !doctorCourseArgs.containsKey('courseId')) return _unDefinedRoute();
        return MaterialPageRoute(
          builder: (_) => DoctorCourseDetailsScreen(
            courseId: doctorCourseArgs['courseId'] as int,
            courseTitle: doctorCourseArgs['courseTitle'] as String? ?? 'Unknown Course',
          ),
        );

      case Routes.doctorQuestionDetails: 
        final questionArgs = args as Map<String, dynamic>?;
        if (questionArgs == null || !questionArgs.containsKey('discussion')) {
          return _unDefinedRoute();
        }

        return MaterialPageRoute(
          builder: (_) => DoctorQuestionDetailsScreen(
            discussion: questionArgs['discussion'] as DiscussionEntity,
          ),
        );
        
      case Routes.lectureAttendanceDetails:
        final lectureArgs = args as Map<String, dynamic>?;
        if (lectureArgs == null || !lectureArgs.containsKey('title') || !lectureArgs.containsKey('date') || !lectureArgs.containsKey('attendees')) {
          return _unDefinedRoute();
        }
        return MaterialPageRoute(
          builder: (_) => LectureAttendanceDetailsScreen(
            lectureTitle: lectureArgs['title'] as String,
            date: lectureArgs['date'] as String,
            attendees: lectureArgs['attendees'] as List<AttendanceRecordEntity>,
          ),
        );

      // -------------------------
      // TA VIEW ROUTES
      // -------------------------
      case Routes.taDashboard:
        return MaterialPageRoute(builder: (_) => const TaHomeScreen());

      case Routes.taCoursesDetails:
        final taCourseArgs = args as Map<String, dynamic>?;
        if (taCourseArgs == null || !taCourseArgs.containsKey('courseId')) return _unDefinedRoute();
        return MaterialPageRoute(
          builder: (_) => TaCourseDetailsScreen(
            courseId: taCourseArgs['courseId'] as int,
            courseTitle: taCourseArgs['courseTitle'] as String? ?? 'Unknown Course',
          )
        );

      case Routes.taAssignmentGrades:
        return MaterialPageRoute(
          builder: (_) => const TaAssignmentGradeScreen(),
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
