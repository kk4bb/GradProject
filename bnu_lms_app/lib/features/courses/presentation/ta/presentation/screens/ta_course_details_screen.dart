import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class TaCourseDetailsScreen extends StatelessWidget {
  const TaCourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    final isLight = themeProvider.isLightTheme();

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
              size: 20.sp,
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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: const CourseHeaderCard(
                title: 'Data Structures (Section B)',
                courseCode: 'CS101',
                instructor: 'Lead: Dr. Mitchell',
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
              labelStyle: AppLightTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 14.sp),
              unselectedLabelStyle: AppLightTextStyles.titleMedium.copyWith(fontSize: 14.sp),
              tabAlignment: TabAlignment.start,
              dividerColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                  const CourseStudentsTab(),

                  // 3. Assignments (Custom TA Version with Grading Actions)
                  const TaCourseAssignmentsTab(),

                  // 4. Quizzes (Reused)
                  const CourseQuizzesTab(),

                  // 5. Materials (Reused)
                  const CourseMaterialsTab(),

                  // 6. Attendance (Reused)
                  const CourseAttendanceTab(),

                  // 7. Grades (Reused)
                  const CourseGradesTab(),
                ],
              ),
            ),
          ],
        ),

        // Optional: TA might not have a general "Add" FAB, usually contextual
      ),
    );
  }
}