import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../shared/config/theme/app_dark_text_styles.dart';
import '../../../../../../shared/config/theme/app_light_text_styles.dart';
import '../../../../../../shared/providers/theme_provider.dart';
import '../../../../../../shared/resources/colors_manager.dart';

import '../../../shared_widgets/course_header_card.dart';
import '../widgets/doctor_courses_details/about_course_section.dart';
import '../widgets/courses_details_tabs/course_assignments_tab.dart';
import '../widgets/courses_details_tabs/course_attendance_tab.dart';
import '../widgets/courses_details_tabs/course_grades_tab.dart';
import '../widgets/courses_details_tabs/course_materials_tab.dart';
import '../widgets/courses_details_tabs/course_quizzes_tab.dart';
import '../widgets/courses_details_tabs/course_students_tab.dart';
import '../widgets/doctor_courses_details/learning_outcomes_section.dart';
import '../widgets/doctor_courses_details/next_session_section.dart';
import '../widgets/doctor_courses_details/overview_stats_row.dart';
import '../../../../../../shared/network/repositories/course_repository.dart';
import '../../../../data/models/course_model.dart';


class DoctorCourseDetailsScreen extends StatefulWidget {
  const DoctorCourseDetailsScreen({super.key});

  @override
  State<DoctorCourseDetailsScreen> createState() => _DoctorCourseDetailsScreenState();
}

class _DoctorCourseDetailsScreenState extends State<DoctorCourseDetailsScreen> {
  final CourseRepository _courseRepository = CourseRepository();
  late Future<CourseDetail> _courseDetailFuture;
  int? _courseId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_courseId == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _courseId = args['courseId'] as int;
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
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: CourseHeaderCard(
                    title: course.title,
                    courseCode: 'CS${course.id}',
                    instructor: course.instructorName,
                    icon: Icons.data_object,
                  ),
                ),

                TabBar(
                  isScrollable: true,
                  indicatorColor: ColorsManager.blue,
                  labelColor: ColorsManager.blue,
                  unselectedLabelColor: ColorsManager.grayMedium,
                  labelStyle: AppLightTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700),
                  unselectedLabelStyle: AppLightTextStyles.titleMedium,
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Students'),
                    Tab(text: 'Assignments'),
                    Tab(text: 'Quizzes'),
                    Tab(text: 'Materials'),
                    Tab(text: 'Attendance'),
                    Tab(text: 'Grades'),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      // 1. Overview Tab Content
                      SingleChildScrollView(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const OverviewStatsRow(),
                            SizedBox(height: 24.0),
                            AboutCourseSection(description: course.description),
                            SizedBox(height: 24.0),
                            const LearningOutcomesSection(),
                            SizedBox(height: 24.0),
                            const NextSessionSection(),
                            SizedBox(height: 80.0),
                          ],
                        ),
                      ),

                      // 2. Students Tab
                      CourseStudentsTab(courseId: course.id),

                      // 3. Assignments Tab
                      CourseAssignmentsTab(courseId: course.id),

                      // 4. Quizzes Tab
                      CourseQuizzesTab(courseId: course.id),

                      // 5. Materials Tab
                      CourseMaterialsTab(course: course),

                      // 6. Attendance Tab
                      CourseAttendanceTab(courseId: course.id),

                      // 7. Grades Tab
                      CourseGradesTab(courseId: course.id),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
