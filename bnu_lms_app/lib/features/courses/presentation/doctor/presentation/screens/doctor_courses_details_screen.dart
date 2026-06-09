import 'package:bnu_lms_app/features/courses/data/models/course_model.dart';
import 'package:bnu_lms_app/shared/network/repositories/course_repository.dart';
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


class DoctorCourseDetailsScreen extends StatefulWidget {
  const DoctorCourseDetailsScreen({super.key});

  @override
  State<DoctorCourseDetailsScreen> createState() => _DoctorCourseDetailsScreenState();
}

class _DoctorCourseDetailsScreenState extends State<DoctorCourseDetailsScreen> {
  final CourseRepository _courseRepository = CourseRepository();
  CourseDetail? _courseDetail;
  bool _isLoading = true;
  String _errorMessage = '';
  int? _courseId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_courseId == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      debugPrint("DEBUG: DoctorCourseDetailsScreen args: $args");
      if (args is Map<String, dynamic>) {
        _courseId = args['courseId'] as int?;
      }
      
      if (_courseId != null) {
        _fetchCourseDetails();
      } else {
        setState(() {
          _errorMessage = 'No course ID provided (Arguments: $args)';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchCourseDetails() async {
    try {
      final details = await _courseRepository.getCourseDetails(_courseId!);
      if (mounted) {
        setState(() {
          _courseDetail = details;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

    if (_isLoading) {
      return Scaffold(
        backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage.isNotEmpty || _courseDetail == null) {
      return Scaffold(
        backgroundColor: isLight ? ColorsManager.lightBackground : ColorsManager.darkBackground,
        body: Center(child: Text(_errorMessage)),
      );
    }

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
              size: 20,
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
            // 1. The Shared Header Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: CourseHeaderCard(
                title: _courseDetail!.title,
                courseCode: 'N/A', // TODO: Add to model if needed
                instructor: _courseDetail!.instructorName,
                icon: Icons.data_object,
              ),
            ),

            // 2. The Tab Bar
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

            // 3. The Tab Content (Scrollable)
            Expanded(
              child: TabBarView(
                children: [
                  // 1. Overview Tab Content
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const OverviewStatsRow(),
                        const SizedBox(height: 24),
                        AboutCourseSection(description: _courseDetail!.description),
                        const SizedBox(height: 24),
                        const LearningOutcomesSection(),
                        const SizedBox(height: 24),
                        const NextSessionSection(),
                        const SizedBox(height: 80), // Padding for FAB
                      ],
                    ),
                  ),

                  // 2. Students Tab
                  CourseStudentsTab(courseId: _courseId!),

                  // 3. Assignments Tab
                  CourseAssignmentsTab(courseId: _courseId!),

                  // 4. Quizzes Tab
                  CourseQuizzesTab(courseId: _courseId!),

                  // 5. Materials Tab
                  CourseMaterialsTab(courseDetail: _courseDetail!),

                  // 6. Attendance Tab
                  CourseAttendanceTab(courseId: _courseId!),

                  // 7. Grades Tab
                  const CourseGradesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}