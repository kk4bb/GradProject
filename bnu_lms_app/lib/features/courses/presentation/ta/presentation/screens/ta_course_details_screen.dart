import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

// Shared Widgets
import '../../../shared_widgets/course_header_card.dart';

// TA Specific Overview (Or reuse Doctor if identical)
import '../widgets/course_details/ta_course_overview_tab.dart';

// Reused Doctor Tabs (Clean Architecture)
import '../../../doctor/presentation/widgets/courses_details_tabs/course_students_tab.dart';
import '../../../doctor/presentation/widgets/courses_details_tabs/course_quizzes_tab.dart';
import '../../../doctor/presentation/widgets/courses_details_tabs/course_materials_tab.dart';
import '../../../doctor/presentation/widgets/courses_details_tabs/course_attendance_tab.dart';
import '../../../doctor/presentation/widgets/courses_details_tabs/course_grades_tab.dart';

// The New Assignments Tab (Code provided below)
import '../widgets/course_details/ta_course_assignments_tab.dart';

import '../../../../../../shared/network/repositories/course_repository.dart';
import '../../../../data/models/course_model.dart';

class TaCourseDetailsScreen extends StatefulWidget {
  const TaCourseDetailsScreen({super.key});

  @override
  State<TaCourseDetailsScreen> createState() => _TaCourseDetailsScreenState();
}

class _TaCourseDetailsScreenState extends State<TaCourseDetailsScreen> {
  final CourseRepository _courseRepository = CourseRepository();
  late Future<CourseDetail> _courseDetailFuture;
  int? _courseId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_courseId == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      _courseId = args?['courseId'] as int? ?? 1; // Default to 1 for now if no args
      _courseDetailFuture = _courseRepository.getCourseDetails(_courseId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    return FutureBuilder<CourseDetail>(
      future: _courseDetailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }

        final course = snapshot.data!;

        return DefaultTabController(
          length: 7,
          child: Scaffold(
            backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isLight ? ColorsManager.black : ColorsManager.white,
                  size: 20.0,
                ),
              ),
              title: Text(
                'Course Details',
                style: isLight
                    ? AppLightTextStyles.headlineLarge
                    : AppDarkTextStyles.headlineLarge,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert_rounded,
                    color: isLight ? ColorsManager.black : ColorsManager.white,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                // 1. The Header Banner (Fixed at Top)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: CourseHeaderCard(
                    title: course.title,
                    courseCode: 'CS${course.id}',
                    instructor: course.instructorName,
                    icon: Icons.code,
                  ),
                ),

                // 2. The Tab Bar
                TabBar(
                  isScrollable: true,
                  indicatorColor: const Color(0xFF2FBAD7), // TA Cyan
                  indicatorWeight: 3,
                  labelColor: const Color(0xFF2FBAD7),
                  unselectedLabelColor: ColorsManager.grayMedium,
                  labelStyle: AppLightTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 14.0),
                  unselectedLabelStyle: AppLightTextStyles.titleMedium.copyWith(fontSize: 14.0),
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Students'),
                    Tab(text: 'Assignments'), // Custom TA Version
                    Tab(text: 'Quizzes'),
                    Tab(text: 'Materials'),
                    Tab(text: 'Attendance'),
                    Tab(text: 'Grades'),
                  ],
                ),

                // 3. The Tab Content
                Expanded(
                  child: TabBarView(
                    children: [
                      // 1. Overview (Your specific TA Overview with Labs timeline)
                      const TaCourseOverviewTab(),

                      // 2. Students (Reused)
                      CourseStudentsTab(courseId: course.id),

                      // 3. Assignments (Custom TA Version with Grading Actions)
                      const TaCourseAssignmentsTab(),

                      // 4. Quizzes (Reused)
                      CourseQuizzesTab(courseId: course.id),

                      // 5. Materials (Reused)
                      CourseMaterialsTab(course: course),

                      // 6. Attendance (Reused)
                      CourseAttendanceTab(courseId: course.id),

                      // 7. Grades (Reused)
                      CourseGradesTab(courseId: course.id),
                    ],
                  ),
                ),
              ],
            ),

            // Optional: TA might not have a general "Add" FAB, usually contextual
          ),
        );
      }
    );
  }
}